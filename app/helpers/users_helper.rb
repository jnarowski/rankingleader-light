module UsersHelper
  def role_id_form_column(record, input_name)
    select :record, :role_id, Role.find(:all).collect {|r| [ r.name, r.id ] }, :name => input_name, :include_blank => false
  end

  def writer_id_form_column(record, input_name)
    select :record, :writer_id, Writer.find(:all).collect {|r| [ r.name, r.id ] }, :name => input_name, :prompt => 'Select Writer'
  end

  def writer_id_column(record)
    record.writer.name if record.writer
  end
  
  def role_id_column(record) 
    record.role.name if record.role
  end
  
end