    def clean_app
        ApplicationsDetail.includes(:database_detail).where(:database_details=>{:database_details_stage=>10}).where(:company_id=>session[:company_id])
    end

    def current_app
        return 0 if session[:user_id].nil? || (@controller=="apps" && session[:admin]=='u')
        if params[:id].nil! 
        @current_app=clean_app.find_by_database_detail_id(params[:id])
        raise ActiveRecord::RecordNotFound if @current_app.nil?
        @config_val=@current_app.configuration_state 
        @application_name=@current_app["application_name"]
        @DB=@current_app.database_detail if params[:id].nil!
        @DB_id=@DB.id
        @li_has={} if @li_has.nil?
        end
    end


    def include_hash(a=true)
        @DB=clean_app.find_by_database_detail_id(params[:id]).database_detail if @DB.nil?
        if a
        @SCHEMA_DETAILS_HASH=@DB.schema_hash
        else
        load "#{Rails.root}/ta/schema_hash_#{@DB.database_details_name.downcase}_#{@DB.id}.rb"
        @SCHEMA_DETAILS_HASH=@@SCHEMA_DETAILS_HASH
        @@SCHEMA_DETAILS_HASH=nil
        @JOINS_DETAILS_HASH=@@JOINS_DETAILS_HASH
        @@JOINS_DETAILS_HASH=nil
        end
    end

    def load_joins_from_schema
        load "#{Rails.root}/ta/schema_hash_#{@DB.database_details_name.downcase}_#{@DB.id}.rb"
        @JOINS_DETAILS_HASH=@@JOINS_DETAILS_HASH
        @@JOINS_DETAILS_HASH=nil
    end

    def view_from_hash
        @Tables={}
        @Views={}
        schema=[]
        @SCHEMA_DETAILS_HASH.each{|k,v|
            hash= (v[:type]=='BASE TABLE') ? @Tables: @Views
            hash[k]={} if hash[k].nil?
            hash[k][:table_name]=v[:table_name]
            hash[k][:name]=v[:name]
            hash[k][:schema_name]=v[:schema_name]
            schema<<v[:schema_name]
            hash[k][:fields]=v[:fields]
            hash[k][:fns]=v[:fns]
        }
        @no_schema=schema.uniq.count==1
    end

    def view_from_hash_for_report
        direct_Joins=@DB.joins_hash.un[:joins_hash] rescue {}
        indirect_joins=@DB.joins_hash.un[:intermediate_tables] rescue []
        @Tables={}
        @Views={}
        @SCHEMA_DETAILS_HASH.each{|k,v|
            v[:fields]=extract_fns(v[:fields])
            if !v[:fields].empty?
                hash= (v[:type]=='BASE TABLE') ? @Tables: @Views
                hash[k]={} if hash[k].nil?
                hash[k][:table_name]=v[:fns] || v[:table_name]
                hash[k][:name]=hash[k][:table_name]
                hash[k][:fields]=v[:fields]
                hash[k][:djoins]=direct_Joins[k].keys.join(',') rescue ""
                hash[k][:ijoins]=indirect_joins[k].join(',') rescue ""
            end
        }
    end

    def extract_fns(fields)
        fields.reject{|key,value| value[:fns].nil? }.each{|key,value|
            value[:column_name]=value[:fns]
            value[:column_type]=value[:native_type]
        } rescue nil
    end


    def re_save_schema(schema=@SCHEMA_DETAILS_HASH)
        @DB.database_hash=schema
        @DB.save!
    end


    def re_save_joins
        current_app
        fnsj=JoinsDetail.find_all_by_database_detail_id(@DB.id)
        joins_hash={}
        fnsj.each{|d|
            table_primary=d["table_primary"]
            table_foreign=d["table_foreign"]
            field_primary=d["field_primary"]
            field_foreign=d["field_foreign"]

            joins_hash[table_primary]={} if joins_hash[table_primary].nil?
            joins_hash[table_foreign]={} if joins_hash[table_foreign].nil?
            (joins_hash[table_primary][table_foreign] ||= []) << [field_primary,field_foreign]
            (joins_hash[table_foreign][table_primary] ||= []) << [field_primary,field_foreign]
        }
        intermediate_tables=Hash[params[:intermediate_tables].map{|k,v| [k.to_i,v.collect{|d| d.to_i}]}] if !params[:intermediate_tables].nil?
        @DB.joins_hash={joins_hash:joins_hash,intermediate_tables:intermediate_tables}
        @DB.save!
    end


    def keywords
        include_hash false
        gon.keywords=@SCHEMA_DETAILS_HASH.collect{|k,v|
            [k,v[:fields].keys.collect{|d| "#{k}.#{d}" }]
        }.flatten
    end


    def extract_schema_information(con,new_db_id)
        db_name=con.get_db_name
        tables_name = con._rake_table_info(db_name)

        File.open("#{Rails.root}/ta/schema_hash_#{db_name.downcase}_#{new_db_id}.rb", 'w') do |file|
        file_puts=""
        file_puts+= "###=============The Schema as Hash generated for Database #{db_name} Created at : #{Time.now} =============###\n"
        file_puts+= "@@SCHEMA_DETAILS_HASH = { \n"   #start of schema
        tables_name.each do |table_name|
            result_set =con._rake_columns_info(table_name[1],db_name)

            file_puts+= "\n\t'#{table_name[0]}.#{table_name[1]}' =>  { \n"  #start of tables
            file_puts+= "\t table_name: '#{table_name[1]}' ,\n"
            file_puts+= "\t schema_name: '#{table_name[0]}' ,\n" if !table_name[0].empty? && !table_name[0]!="dbo"
            file_puts+= "\t type: '#{table_name[2]}' ,\n"
            file_puts+= "\t fields: { \n"   #start of fields
            ### call the function from the factory class
                    #p result_set
                    result_set.each do |column_name|
                        file_puts+= "\n\t\t '#{column_name[0]}'=> {\n"
                        file_puts+= " \t\t\t column_name: '#{column_name[0]}' , \n"
                        file_puts+= " \t\t\t column_type:  '#{column_name[1]}' \n"
                        file_puts+= "\t\t\t },"
                    end
                    file_puts.chop!
                    file_puts+= "\n\t\t}"   #end of fields
                    file_puts+= "\n\t},"    #end of tables
                end
                file_puts.chop!
            file_puts+= "\n}\n\n"   #end of schema

        ################# show default joins Details ###########################
        ### call the function from the factory class
        joins_result_set = con._rake_joins_info(db_name)
        ################# end default joins Details ############################
        file_puts+= "\n\n###================== JOINS DETAILS ON THE DATABASE #{db_name} DATE: #{Time.now} ======== ####\n"
        file_puts+= "@@JOINS_DETAILS_HASH = {\n"
        j_count = 1
        joins_result_set.each do |join|
                file_puts+= "\n\t #{j_count} => {\n"
                file_puts+= "\t\t fk_table_name: '#{join[0]}' ,\n"
                file_puts+= "\t\t fk_column_name: '#{join[1]}' ,\n"
                file_puts+= "\t\t pk_table_name: '#{join[2]}',\n"
                file_puts+= "\t\t pk_column_name: '#{join[3]}' \n"
                file_puts+= "\t\t },"
                j_count = j_count +1
            end
            file_puts.chop!
            file_puts+= "\n\t}"
            ######################################Joins Details End ##########################
            file.puts file_puts
            file.close
        end
    end
