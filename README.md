# Lesson-5 検索機能

### ①searchコントローラー作成
```
rails g controller search
```
### ②searchコントローラーに記述
```
class SearchController < ApplicationController
    def search
        @model = params["search"]["model"]      #選択したmodelを@modelに代入
        @value = params["search"]["value"]      #検索にかけた文字列を@valueに代入
        @how = params["search"]["how"]          #選択した検索方法を@howに代入
        @datas = search_for(@how, @model, @value)       #@howと@modelと@valueを引数としてインスタンス変数を定義
    end
    
    private
    
    def match(model, value)     #def search_forでhowがmatchだった場合の処理
        if model == 'user'      #modelがuserの場合の処理
            User.where(name: value)     #whereでvalueと完全一致するnameを探します
        elsif model == 'book'
            Book.where(title: value)
        end
    end
    
    def forward(model, value)
        if model == 'user'
            User.where("name LIKE ?", "#{value}%")      #whereでvalueと前方一致するnameを探します
        elsif model == 'book'
            Book.where("title LIKE ?", "#{value}%")
        end
    end
    
    def backward(model, value)
        if model == 'user'
            User.where("name LIKE ?", "%#{value}")      #whereでvalueと後方一致するnameを探します
        elsif model == 'book'
            Book.where("title LIKE ?", "%#{value}")
        end
    end
    
    def partical(model, value)
        if model == 'user'
            User.where("name LIKE ?", "%#{value}%")     #whereでvalueと部分一致するnameを探します
        elsif model == 'book'
            Book.where("title LIKE ?", "%#{value}%")
        end
    end
    
    def search_for(how, model, value)       #searchアクションで定義した情報が引数に入っている
        case how                            #検索方法のhowの中身がどれなのかwhenの条件分岐の中から探す処理
        when 'match'
            match(model, value)             #検索方法の引数に(model, value)を定義している
        when 'forward'                      #howがmatchの場合は def match の処理に進みます
            forward(model, value)
        when 'backward'
            backward(model, value)
        when 'partical'
            partical(model, value)
        end
    end
end
```
### ③routesに追記
```
get '/search' => 'search#search'
```
### ④_header.html.erbに追記
```
    <div clas="row">
      <div class="col-xs-6 col-xs-offset-3 text-center" style="margin-top:25px;">
        <% if user_signed_in? %>
        <%= form_with url: search_path, method: :get, local: true do |f| %>
          <%= f.text_field 'search[value]' %>
          <%= f.select 'search[model]', options_for_select({ "User" => "user", "Book" => "book"}) %>
          <%= f.select 'search[how]', options_for_select({ "完全一致" => "match", "前方一致" => "forward", "後方一致" => "backward", "部分一致" => "partical"}) %>
          <%= f.submit :"検索" %>
        <% end %>
        <% end %>
      </div> 
    </div>
```
### search/search.html.erb
```
<div class="container">
    <div class="col-xs-12">
        <% if @model == "user" %>
        <h2>Users search for '<%= @value %>'</h2>
        <table class="table">
            <thead>
                <tr>
                    <th></th>
                    <th>Name</th>
                    <th>Introduction</th>
                </tr>
            </thead>
            <% @datas.each do |user| %>
                <tbody>
                    <tr>
                        <th>
                            <%= attachment_image_tag(user, :profile_image, :fill, 40, 40, fallback: "no_image.jpg", size: '40x40') %>
                        </th>
                        <th>
                            <%= user.name %>
                        </th>
                        <th>
                            <%= user.introduction %>
                        </th>
                    </tr>
                </tbody>
            <% end %>
            <% elsif @model == "book" %>
            <h2>Books search for '<%= @value %>'</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th></th>
                        <th>Title</th>
                        <th>Opinion</th>
                    </tr>
                </thead>
                <% @datas.each do |book| %>
                    <tbody>
                        <tr>
                            <th>
                                <%= attachment_image_tag(book.user, :profile_image, :fill, 40, 40, fallback: "no_image.jpg", size: '40x40') %>
                            </th>
                            <th>
                                <%= book.title %>
                            </th>
                            <th>
                                <%= book.body %>
                            </th>
                        </tr>
                    </tbody>
                <% end %>
            <% end %>
        </table>
    </div>
</div>
```