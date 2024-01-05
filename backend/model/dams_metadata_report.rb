class DamsMetadataReport < AbstractReport
  register_report(params: [['from', Date, "The start of the report range"]])

  def initialize(params, job, db)
    super

    from = params['from']
    @from = DateTime.parse(from).to_time.strftime('%Y%m%d')
  end

  def query_string
    'SELECT do.digital_object_id AS "asset_id",
    ao.component_id AS "accession_no",
    ao.id AS "ao_id",
    r.identifier AS "archives_collection_id",
    "" AS "artist_creator",
    rights_statement.rights_type_id AS "copyright",
    ao.last_modified_by AS "description_writer",
    "" AS "description",
    IF(ao.restrictions_apply = 1, "Restricted", "No known restrictions") AS "restrictions",
    rights_statement.status_id AS "rights_status",
    "" AS "rights_uri",
    ao.ref_id AS "source_system",
    do.title AS "do_title"

    FROM digital_object AS do
    LEFT JOIN instance_do_link_rlshp ON do.id = instance_do_link_rlshp.digital_object_id
    LEFT JOIN instance ON instance.id = instance_do_link_rlshp.instance_id
    LEFT JOIN archival_object AS ao ON ao.id = instance.archival_object_id
    LEFT JOIN resource AS r ON r.id = ao.root_record_id
    LEFT JOIN rights_statement ON rights_statement.resource_id = r.id

    WHERE do.create_time >' +  db.literal(@from)
  end

  def fix_row(row)
    creators = AgentDamsSubreport.new(self, row[:ao_id]).get_content
    row[:artist_creator] = creators[0][:ref] if creators
    row.delete(:ao_id)
    row[:description] = row[:do_title] + ". " + (row[:artist_creator] ? row[:artist_creator] + ". " : "") + (row[:copyright].eql?(1260) ? "Copyright Georgia O'Keeffe Museum." : "")
    ReportUtils.fix_identifier_format(row, :archives_collection_id)
    ReportUtils.get_enum_values(row, [:copyright])
    ReportUtils.get_enum_values(row, [:rights_status])


    row.keys.each do |header|
      translation_key = "reports.dams_metadata_report.headers.#{header}"
      translation = I18n.t(translation_key, :default => nil)

      if translation
        row[translation] = row.delete(header)
      end
    end
  end
end
