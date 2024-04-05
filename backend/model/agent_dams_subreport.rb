class AgentDamsSubreport < AbstractSubreport

	register_subreport('linked_agent', ['accession', 'archival_object',
		'digital_object', 'digital_object_component', 'event', 'resource',
		'rights_statement'])

	def initialize(parent_custom_report, id)
		super(parent_custom_report)
		@id = id
	end

	# for GOKM - this uses sort names, not primary names
	def query_string
		"select
		  concat_ws(', ',
		    group_concat(distinct name_person.sort_name separator ', '),
		    group_concat(distinct name_software.sort_name separator ', '),
		    group_concat(distinct name_family.sort_name separator ', '),
		    group_concat(distinct name_corporate_entity.sort_name separator ', ')
           ) as ref

		from linked_agents_rlshp
		  
		  left outer join agent_person on agent_person.id
		    = linked_agents_rlshp.agent_person_id
		    
		  left outer join name_person on name_person.agent_person_id
			= agent_person.id
		    
		  left outer join agent_software on agent_software.id
		    = linked_agents_rlshp.agent_software_id
		    
		  left outer join name_software on name_software.agent_software_id
			= agent_software.id
		    
		  left outer join agent_family on agent_family.id
		    = linked_agents_rlshp.agent_family_id
		    
		  left outer join name_family on name_family.agent_family_id
			= agent_family.id

		  left outer join agent_corporate_entity on agent_corporate_entity.id
		    = linked_agents_rlshp.agent_corporate_entity_id
		    
		  left outer join name_corporate_entity
			on name_corporate_entity.agent_corporate_entity_id
			= agent_corporate_entity.id
		  
		where archival_object_id = #{db.literal(@id)}
                group by linked_agents_rlshp.archival_object_id"
	end

	def fix_row(row)
	end

	def self.field_name
		'linked_agent'
	end
end
