

def render_jerror(a)
  render :status => 500, :inline =>{:error => a}.to_json
end

def render_error(a)
  respond_to do |format|
    format.html { render :file => "#{Rails.root}/public/#{a}.html", :status => a,:layout => false }
    format.xml  { head :not_found }
    format.any  { head :not_found }
  end
end



def render_json_response(type, hash)
  unless [ :ok, :redirect, :error ].include?(type)
    raise "Invalid json response type: #{type}"
  end

  default_json_structure = {
    :status => type,
    :html => nil,
    :message => nil,
    :to => nil }.merge(hash)
    render_options = {:json => default_json_structure}
    render_options[:status] = 400 if type == :error
    render(render_options)

  end


  def not_found(message=t(:not_found),status=404 )
    respond_to do |type|
      type.html  { render :inline => "<div class='login_error'><h1>404</h1>#{message}.</div>", :layout => "application", :status => status }
    end
    true
  end




  
def jsv
  "javascript:void(0);"
end




def known_error(exception)

  @nojs=true
  Logging.appenders.file('Debug File', :filename => "log/daily_error/error_#{Time.now.strftime("%m-%d")}.log")
  Logging.logger.root.appenders = 'Debug File'
  Logging.logger.root.level = :error
  Logging.logger["#{Time.now.strftime("%H:%M:%S")}"].error "#{exception.message}\n#{exception.backtrace[0]}"

      # Tower.connection.rollback_db_transaction
      p "Error!!! Error!!! Error!!!"
      p Time.now.strftime("%H:%M:%S")
      p exception.message
      p exception.class
      pp exception.backtrace.select{|d| !d.match(Rails.root.to_s).nil?}
      stack=""
      stack=exception.backtrace[0] if !Rails.env.production?

      msg=exception.message
      status=500

      if exception.class==ActiveRecord::RecordNotFound
        msg=t :not_found
        status=404
      end

      flash.now[:error]=msg.gsub("'",'"')

      respond_to do |format|
       format.html {
        gon.log=request["log"]
        render :inline =>"" ,:layout => true,:status => status
      }
      format.json { render :json =>{:error => msg,:stack=>stack,log:request["log"]}.to_json,:status => status }
    end
  end






