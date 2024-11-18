require 'camping'

Camping.goes :Flix

module Flix
  module Models
    class User < Base
      plugin :timestamps, :force=>true, :update_on_create=>true
    end 
  end

  module Controllers

    class Index
      def get
        @title = "Show page"
        @users = User.all
        render :index
      end
    end

    class New
      def get
        render :new
      end
      def post
        User.new(name: @input.user.name).save
        redirect Index
      end
    end

    class ShowN
      def get(id)
        @user = User[id]
        render :show
      end
    end

    class EditN
      def get(id)
        @user = User[id]
        render :edit
      end
      def post(id)
        @user = User[id]
        @user.update(name: @input.user.name, created_at: @user.created_at, updated_at: @user.updated_at)
        redirect ShowN, id
      end
    end

    class DeleteN
      def get(id)
        User[id].delete
        redirect Index
      end
    end

  end

  module Helpers
  end

  module Views
    def layout
      html do
        head do
          title 'Flix'
          link :rel => 'stylesheet', :type => 'text/css',
          :href => '/styles.css', :media => 'screen'
        end
        body do
          h1 'Flix'
          div.wrapper! do
            self << yield
          end
        end
      end
    end

    def index
      div "Let's go Camping"
      ul do 
        @users.each do |u|
          li u.name
          li u.id
          a "view profile", :href => "/show/#{u.id}"
        end
      end
      a "new user", :href => '/new'
    end

    def show
      p "Hello #{@user.name}"
      a "edit", :href => "/edit/#{@user.id}"
    end

    def new
      div "create a user"
      form :action=>R(New), :method=>:post do
        label "Give me your name!", :for=>:name
        input :type=>:text, :name=>:'user[name]'; br
        input :type=>:submit
      end
      a "back to users", :href => '/' 
    end
    
    def edit
      h2 "Hello #{@user.name} Edit your profile"
      h4 "Edit your profile"
      form :action=>R(EditN, @user.id), :method=>:post do
        label "Give me your name!", :for=>:name
        input :type=>:text, :value=>@user.name, :name=>:'user[name]'; br
        input :type=>:submit
        
      end
      form :action=>R(DeleteN, @user.id), :method=>:delete do 
        input :type=>:hidden, :value=>@user.id
        input :type=>:submit, :value=>"delete"
      end
      a "back to users", :href => '/' 
    end

  end

end

