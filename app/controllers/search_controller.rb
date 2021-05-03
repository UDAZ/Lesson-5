class SearchController < ApplicationController
    def search
        @model = params["search"]["model"]
        @value = params["search"]["value"]
        @how = params["search"]["how"]
        @datas = search_for(@how, @model, @value)
    end
    
    private
    
    def match(model, value)
        if model == 'user'
            User.where(name: value)
        elsif model == 'book'
            Book.where(title: value)
        end
    end
    
    def forward(model, value)
        if model == 'user'
            User.where("name LIKE ?", "#{value}%")
        elsif model == 'book'
            Book.where("title LIKE ?", "#{value}%")
        end
    end
    
    def backward(model, value)
        if model == 'user'
            User.where("name LIKE ?", "%#{value}")
        elsif model == 'book'
            Book.where("title LIKE ?", "%#{value}")
        end
    end 
end
