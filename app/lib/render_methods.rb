def render_msg(msg,location=nil)
    location=location.to_url if location.nil!
    if msg==:saved
        # msg=t(:saved,{name:t(@action)})
        msg=t :saved
    else
        msg=t(msg)
    end
    render_json_response :ok,{message: msg,location:location}
end

def render_save(location,b=false)
    render_msg(:saved,location)
end




def render_j(data={})
render_json_response :ok,data
end

def render_l(loc)
render_json_response :ok,{location:loc}
end


def render_dmsg(msg,location=nil)
    render_json_response :ok,{message: msg,location:location}
end


def rt(msg)
    raise t msg
end

