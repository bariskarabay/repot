6. Bölüm

rails new repot
cd repot
dir

rails generate scaffold Product title:string description:text image_url:string price:decimal

rake db:migrate

rails s

//seeds.rb dosyası 
        Product.delete_all
        Product.create(title: 'Ruby ile programlama', 
  description: 
          % {<p>
        Ruby ile programlamaya giris bla bla bla bla bla
            </p>},
        image_url: 'resim.jpg',
        price: 49.98)

rake db:seed

// app/assets/stylesheets/products.css.scss dosyasının içeriği aşağıdaki gibidir

 /* START_HIGHLIGHT */
.products {
  table {
    border-collapse: collapse;
  }

  table tr td {
    padding: 5px;
    vertical-align: top;
  }

  .list_image {
    width:  60px;
    height: 70px;
  }

  .list_description {
    width: 60%;

    dl {
      margin: 0;
    }

    dt {
      color:        #244;
      font-weight:  bold;
      font-size:    larger;
    }

    dd {
      margin: 0;
    }
  }

  .list_actions {
    font-size:    x-small;
    text-align:   right;
    padding-left: 1em;
  }

  .list_line_even {
    background:   #e0f8f8;
  }

  .list_line_odd {
    background:   #f8b0f8;
  }
}
/* END_HIGHLIGHT */



// app/views/products/index.html.erb dosyasının içeriği aşağıdaki gibi değiştirildi

 <h1>Listing products</h1>

<table>
<% @products.each do |product| %>
  <tr class="<%= cycle('list_line_odd', 'list_line_even') %>">
    <td>
      <%= image_tag(product.image_url, class: 'list_image') %>
    </td>
    <td class="list_description">
      <dl>
        <dt><%= product.title %></dt>
        <dd><%= truncate(strip_tags(product.description), length: 80) %></dd>
      </dl>
    </td>
    <td class="list_actions">
      <%= link_to 'Show', product %><br/>
      <%= link_to 'Edit', edit_product_path(product) %><br/>
      <%= link_to 'Destroy', product, method: :delete,
                  data: { confirm: 'Are you sure?' } %>
    </td>
  </tr>
<% end %>
</table>
<br />
<%= link_to 'New product', new_product_path %>


rake db:rollback


git config --global --add user.name "Baris Karabay"
git config --global --add user.email bariskarabay@yandex.com

git config --global --list

git init
git add .
git commit -m "Repot Scaffold"
git checkout .

7. Bölüm

// app/models/product.rb dosyasında aşağıdaki değişiklikler yapıldı

    validates :title, :description, :image_url, presence: true
    validates :price, numericality: {greater_than_or_equal_to: 0.01}
    validates :title, uniqueness: true
    validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: 'gif, png veya jpg resmi seciniz.'
 
// test/controllers/products_controller_test.rb dosyasında aşağıdaki yordamların içeriği değiştirildi

      @product = products(:one)
      @update = {
      title: 'Barissss Karabayyy',
      description: 'deneme deneme deneme dneeme deneme deneme ',
      image_url: 'resim.jpg',
      price:      19.84
    }
      test "should create product" do
      assert_difference('Product.count') do
      post :create, product: @update
      end
 
      test "should update product" do
      patch :update, id: @product, product: @update
      assert_redirected_to product_path(assigns(:product))
      end
// test/models/product_test.rb dosyasında aşağıdaki data validate'ler eklendi

    test "urun ozellikleri bos gecilemez" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?

// test dosyası kontrol edildi

    rake test:models 

// test/models/product_test.rb dosyasında Price alanını -1 veya 0 olamamaz bunun için aşağıdaki geçerlilik kontrollerini yazdık

test "product price must be positive" do
    product = Product.new(title:       "Bariss",
                          description: "Yazılım mühendisliği",
                          image_url:   "resim.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
      product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], 
      product.errors[:price]

    product.price = 1
    assert product.valid?
  end

// test/models/product_test.rb dosyasında Resim uzantılarının geçerlilik kontrolü aşağıda yapılmıştır 

def new_product(image_url)
    Product.new(title:       "My Book Title",
                description: "yyy",
                price:       1,
                image_url:   image_url)
  end
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

// test/fixtures/products.yml dosyasında yeni test verileri eklendi

#START:ruby

ruby:
  title: Baris Karabay
  description: Firat Universitesi Teknoloji Fakultesi Yazilim Muhendisligi 4. Sinif Ogrencisi
  price: 5000
  image_url: resim.jpg
#END:ruby 

// test/models/product_test.rb dosyasında benzsersiz title geçerlilik kontrolü eklendi

 test "product is not valid without a unique title" do
    product = Product.new(title:       products(:ruby).title,
                          description: "denemeee", 
                          price:       1, 
                          image_url:   "resim.gif")

    assert product.invalid?
    assert_equal ["Bu title daha onceden alinmis"], product.errors[:title]
  end

// test/models/product_test.rb dosyasında aşağıdaki kod kullanılarak hata verdiğinde bir hata tablosu oluşturmaya yarar.

test "product is not valid without a unique title - i18n" do
    product = Product.new(title:       products(:ruby).title,
                          description: "yyy", 
                          price:       1, 
                          image_url:   "fred.gif")

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end

8. Bölüm

// Store adında yeni bir controller ve index adında bir action oluşturuldu 

rails generate controller Store index

// config/routes.rb dosyası aşağıdaki gibi değiştirildi

Rails.application.routes.draw do
  get 'store/index'

  resources :products

  root to: 'store#index', as: 'store'
end

// app/controllers/store_controller.rb dosyasının index action'ı aşağıdaki gibi değiştirildi. Title alanına göre sıralanarak listelendi yapıldı

def index
    @products = Product.order(:title)
  end

// app/views/store/index.html.erb dosyasının içeriği aşağıdaki gibi değiştirildi

<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h1>Your Pragmatic Catalog</h1>

<% @products.each do |product| %>
  <div class="entry">
    <%= image_tag(product.image_url) %>
    <h3><%= product.title %></h3>
    <%= sanitize(product.description) %>
    <div class="price_line">
      <span class="price"><%= product.price %></span>
    </div>
  </div>
<% end %>

// app/assets/stylesheets/store.css.scss dosyası aşağıdaki gibi değiştirildi

// Place all the styles related to the Store controller here.
// They will automatically be included in application.css.
// You can use Sass (SCSS) here: http://sass-lang.com/

/* START_HIGHLIGHT */
.store {
  h1 {
    margin: 0;
    padding-bottom: 0.5em;
    font:  150% sans-serif;
    color: #226;
    border-bottom: 3px dotted #77d;
  }

  /* An entry in the store catalog */
  .entry {
    overflow: auto;
    margin-top: 1em;
    border-bottom: 1px dotted #77d;
    min-height: 100px;

    img {
      width: 80px;
      margin-right: 5px;
      margin-bottom: 5px;
      position: absolute;
    }

    h3 {
      font-size: 120%;
      font-family: sans-serif;
      margin-left: 100px;
      margin-top: 0;
      margin-bottom: 2px;
      color: #227;
    }

    p, div.price_line {
      margin-left: 100px;
      margin-top: 0.5em; 
      margin-bottom: 0.8em; 
    }

    .price {
      color: #44a;
      font-weight: bold;
      margin-right: 3em;
    }
  }
}
/* END_HIGHLIGHT */

// app/views/layouts/application.html.erb dosyası aşağıdaki gibi değiştirildi

<!-- START:head -->
<!DOCTYPE html>
<html>
<head>
<!-- START_HIGHLIGHT -->
  <title>Pragprog Books Online Store</title>
<!-- END_HIGHLIGHT -->
  <!-- <label id="code.slt"/> --><%= stylesheet_link_tag    "application", media: "all",
    "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %><!-- <label id="code.jlt"/> -->
  <%= csrf_meta_tags %><!-- <label id="code.csrf"/> -->
</head>
<!-- END:head -->
<body class="<%= controller.controller_name %>">
<!-- START_HIGHLIGHT -->
  <div id="banner">
    <%= image_tag("logo.png") %>
    <%= @page_title || "Pragmatic Bookshelf" %><!-- <label id="code.depot.e.title"/> -->
  </div>
  <div id="columns">
    <div id="side">
      <ul>
        <li><a href="http://www....">Home</a></li>
        <li><a href="http://www..../faq">Questions</a></li>
        <li><a href="http://www..../news">News</a></li>
        <li><a href="http://www..../contact">Contact</a></li>
      </ul>
    </div>
    <div id="main">
<!-- END_HIGHLIGHT -->
      <%= yield %><!-- <label id="code.depot.e.include"/> -->
<!-- START_HIGHLIGHT -->
    </div>
  </div>
<!-- END_HIGHLIGHT -->
</body>
</html>

// app/assets/stylesheets/application.css.scss dosyası aşağıdaki gibi değiştirildi

/*
 * This is a manifest file that'll be compiled into application.css, which will
 * include all the files listed below.
 * 
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets,
 * vendor/assets/stylesheets, or vendor/assets/stylesheets of plugins, if any,
 * can be referenced here using a relative path.
 * 
 * You're free to add application-wide styles to this file and they'll appear
 * at the top of the compiled file, but it's generally better to create a new
 * file per style scope.
 * 
 *= require_self
 *= require_tree .
 */

/* START_HIGHLIGHT */
#banner {
  background: #9c9;
  padding: 10px;
  border-bottom: 2px solid;
  font: small-caps 40px/40px "Times New Roman", serif;
  color: #282;
  text-align: center;

  img {
    float: left;
  }
}

#notice {
  color: #000 !important;
  border: 2px solid red;
  padding: 1em;
  margin-bottom: 2em;
  background-color: #f0f0f0;
  font: bold smaller sans-serif;
}

#columns {
  background: #141;

  #main {
    margin-left: 17em;
    padding: 1em;
    background: white;
  }

  #side {
    float: left;
    padding: 1em 2em;
    width: 13em;
    background: #141;
  
    ul {
      padding: 0;
      li {
        list-style: none;
        a {
          color: #bfb;
          font-size: small;
        }
      }
    }
  }
}
/* END_HIGHLIGHT */


// app/views/store/index.html.erb dosyası aşağıdaki gibi değiştirildi


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h1>Your Pragmatic Catalog</h1>

<!-- START_HIGHLIGHT -->
<% cache ['store', Product.latest] do %>
<!-- END_HIGHLIGHT -->
  <% @products.each do |product| %>
<!-- START_HIGHLIGHT -->
    <% cache ['entry', product] do %>
<!-- END_HIGHLIGHT -->
      <div class="entry">
        <%= image_tag(product.image_url) %>
        <h3><%= product.title %></h3>
        <%= sanitize(product.description) %>
        <div class="price_line">
    <!-- START:currency -->
          <span class="price"><%= number_to_currency(product.price) %></span>
    <!-- END:currency -->
        </div>
      </div>
<!-- START_HIGHLIGHT -->
    <% end %>
<!-- END_HIGHLIGHT -->
  <% end %>
<!-- START_HIGHLIGHT -->
<% end %>
<!-- END_HIGHLIGHT -->

// test/controllers/store_controller_test.rb dosyası aşağıdaki gibi değiştirildi

require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select '#columns #side a', minimum: 4
    assert_select '#main .entry', 3
    assert_select 'h3', 'Programming Ruby 1.9'
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

end

// test/fixtures/products.yml dosyası aşağıdaki gibi değiştirildi

# Read about fixtures at
# http://api.rubyonrails.org/classes/ActiveRecord/Fixtures.html
one:
  title: MyString
  description: MyText
  image_url: MyString
  price: 9.99

two:
  title: MyString
  description: MyText
  image_url: MyString
  price: 9.99
#START:ruby

ruby: 
  title:       Programming Ruby 1.9
  description: 
    Ruby is the fastest growing and most exciting dynamic
    language out there.  If you need to get working programs
    delivered fast, you should add Ruby to your toolbox.
  price:       49.50
  image_url:   ruby.png 
#END:ruby



// app/views/store/index.html.erb dosyasında undefined method `latest' diye bir hata aldım. <% cache ['store', Product.latest] do %> kısmında ki latest metodunu kaldırdığım zaman çalıştı.

<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>
<h1>Your Pragmatic Catalog</h1>
<!-- START_HIGHLIGHT -->
<% cache ['store', Product] do %>
<!-- END_HIGHLIGHT -->
  <% @products.each do |product| %>
<!-- START_HIGHLIGHT -->
    <% cache ['entry', product] do %>
<!-- END_HIGHLIGHT -->
      <div class="entry">
        <%= image_tag(product.image_url) %>
        <h3><%= product.title %></h3>
        <%= sanitize(product.description) %>
        <div class="price_line">
    <!-- START:currency -->
          <span class="price"><%= number_to_currency(product.price) %></span>
    <!-- END:currency -->
        </div>
      </div>
<!-- START_HIGHLIGHT -->
    <% end %>
<!-- END_HIGHLIGHT -->
  <% end %>
<!-- START_HIGHLIGHT -->
<% end %>
<!-- END_HIGHLIGHT -->


// Partial sonuçlarını cache etmek

 config.action_controller.perform_caching = true

// app/models/product.rb dosyasında latest metodunu ekliyoruz.

def self.latest
    Product.order(:updated_at).last
  end

// app/views/store/index.html.erb dosyasını aşağıdaki gibi değiştiriyoruz.


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h1>Your Pragmatic Catalog</h1>

<!-- START_HIGHLIGHT -->
<% cache ['store', Product.latest] do %>
<!-- END_HIGHLIGHT -->
  <% @products.each do |product| %>
<!-- START_HIGHLIGHT -->
    <% cache ['entry', product] do %>
<!-- END_HIGHLIGHT -->
      <div class="entry">
        <%= image_tag(product.image_url) %>
        <h3><%= product.title %></h3>
        <%= sanitize(product.description) %>
        <div class="price_line">
    <!-- START:currency -->
          <span class="price"><%= number_to_currency(product.price) %></span>
    <!-- END:currencyy -->
        </div>
      </div>
<!-- START_HIGHLIGHT -->
    <% end %>
<!-- END_HIGHLIGHT -->
  <% end %>
<!-- START_HIGHLIGHT -->
<% end %>
<!-- END_HIGHLIGHT -->

//  config/environments/development.rb dosyasında ki caching işlemini false yapıyoruz.

  config.action_controller.perform_caching = false

9. BÖLÜM

//













