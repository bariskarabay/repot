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

//  config/environments/development.rb dosyasında ki caching işlemini false yapıyoruz.

  config.action_controller.perform_caching = false

9. BÖLÜM

//

rails generate scaffold cart

rake db:migrate

// app/controllers/concerns/current_cart.rb dosyası

module CurrentCart
  extend ActiveSupport::Concern

  private

      def set_cart
        @cart = Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
        @cart = Cart.create
        session[:cart_id] = @cart.id
      end
  end

// line_item adında yeni bir scaffold yapısı oluşturuyoruz.

rails generate scaffold line_item product:references cart:references

rake db:migrate

// app/models/cart.db

class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
end

// app/models/product.rb dosyası

private

    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end

// app/views/store/index.html.erb dosyasında Bir buton eklemek 


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h1>Your Pragmatic Catalog</h1>

<% cache ['store', Product.latest] do %>
  <% @products.each do |product| %>
    <% cache ['entry', product] do %>
      <div class="entry">
        <%= image_tag(product.image_url) %>
        <h3><%= product.title %></h3>
        <%= sanitize(product.description) %>
        <div class="price_line">
          <span class="price"><%= number_to_currency(product.price) %></span>
<!-- START_HIGHLIGHT -->
          <%= button_to 'Add to Cart', line_items_path(product_id: product) %>
<!-- END_HIGHLIGHT -->
        </div>
      </div>
    <% end %>
  <% end %>
<% end %>

// spp/assets/stylesheets/store/css.scss dosyası aşağıdaki şekilde değiştirildi


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

//#START:inline
    p, div.price_line {
      margin-left: 100px;
      margin-top: 0.5em; 
      margin-bottom: 0.8em; 

      /* START_HIGHLIGHT */
      form, div {
        display: inline;
      }
      /* END_HIGHLIGHT */
    }
//#END:inline

    .price {
      color: #44a;
      font-weight: bold;
      margin-right: 3em;
    }
  }
}
/* END_HIGHLIGHT */

//

// app/controllers/line_items_controller.rb dosyasına aşağıdaki kod parçası eklendş

class LineItemsController < ApplicationController

 include CurrentCart
 before_action :set_cart, only: [:create]
 before_action :set_line, only: [:show, :edit, :update, :destroy]
 
end

// app/controllers/line_items_controller.rb dosyasına aşağıdaki create metodu eklendi

def create
    product = Product.find(params[:product_id])
    @line_item = @cart.line_items.build(product: product)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart,
          notice: 'Line item was successfully created.' }
        format.json { render action: 'show',
          status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
          status: :unprocessable_entity }
      end
    end
  end

// test/controllers/line_items_controller_test.rb dosyası

 test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:ruby).id
    end

    assert_redirected_to cart_path(assigns(:line_item).cart)
  end

// app/views/carts/show.html.erb dosyası aşağıdaki gibi değiştirildi


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h2>Your Pragmatic Cart</h2>
<ul>    
  <% @cart.line_items.each do |item| %>
    <li><%= item.product.title %></li>
  <% end %>
</ul>

10. BÖLÜM

//

rails generate migration add_quantity_to_line_items quantity:integer

// db/migrate/2015...._add_quantity_to_line_items.rb dosyasında aşağıdaki değişiklikler yapılmıştır

class AddQuantityToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :quantity, :integer, default: 1
  end
end

// 

rake db:migrate

// app/models/cart.rb dosyasında aşağıdaki değişiklikler yapılmıştır

class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end
end

// app/controllers/line_items_controller.rb dosyasında aşağıdaki değişiklikler yapılmıştır

class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart,
          notice: 'Line item was successfully created.' }
        format.json { render action: 'show',
          status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
          status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
  #...
end

// app/views/carts/show.html.erb dosyasında aşağıdaki değişiklikler yapılmıştır


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h2>Your Pragmatic Cart</h2>
<ul>    
  <% @cart.line_items.each do |item| %>
<!-- START_HIGHLIGHT -->
    <li><%= item.quantity %> &times; <%= item.product.title %></li>
<!-- END_HIGHLIGHT -->
  <% end %>
</ul>

// 

rails generate migration combine_items_in_cart

// db/migrate/combine_items_in_cart.rb dosyasında aşağıdaki değişiklikler yapılmıştır.


class CombineItemsInCart < ActiveRecord::Migration

  def up
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
      # count the number of each product in the cart
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          # remove individual items
          cart.line_items.where(product_id: product_id).delete_all

          # replace with a single item
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # split items with quantity>1 into multiple items
    LineItem.where("quantity>1").each do |line_item|
      # add individual items
      line_item.quantity.times do 
        LineItem.create cart_id: line_item.cart_id,
          product_id: line_item.product_id, quantity: 1
      end

      # remove original item
      line_item.destroy
    end
  end
end


// app/controllers/carts_controller.rb dosyasında aşağıdaki değişiklikler yapıldı

rake db:migrate

class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  # GET /carts
  # GET /carts.json


  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params[:cart]
    end
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'invalid cart'
    end
end

// repot/test/controllers/line_items_controller_test.rb

#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:ruby).id
    end

    assert_redirected_to cart_path(assigns(:line_item).cart)
  end

  test "should show line_item" do
    get :show, id: @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line_item
    assert_response :success
  end

  test "should update line_item" do
    patch :update, id: @line_item, line_item: { product_id: @line_item.product_id }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item
    end

    assert_redirected_to line_items_path
  end
end

// app/views/carts/show.html.erb dosyasında aşağıdaki değişiklikler yapıldı


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>
<h2>Your Pragmatic Cart</h2>
<ul>    
  <% @cart.line_items.each do |item| %>
    <li><%= item.quantity %> &times; <%= item.product.title %></li>
  <% end %>
</ul>
<!-- START_HIGHLIGHT -->
<%= button_to 'Empty cart', @cart, method: :delete,
    data: { confirm: 'Are you sure?' } %>
<!-- END_HIGHLIGHT -->


// repot/app/controllers/carts_controller.rb dosyasında aşağıdaki değişiklikler yapıldı.

#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cart }
      else
        format.html { render action: 'new' }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    respond_to do |format|
      format.html { redirect_to store_url,
        notice: 'Your cart is currently empty' }
      format.json { head :no_content }
    end
  end

  # ...
  private
  # ...

    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params[:cart]
    end
    def invalid_cart
      logger.error "Attempt to access invalid cart #{params[:id]}"
      redirect_to store_url, notice: 'Invalid cart'
    end
end


// test/controllers/carts_controller_test.rb dosyasında aşağıdaki değişiklikler yapıldı

#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @cart = carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cart" do
    assert_difference('Cart.count') do
      post :create, cart: {  }
    end

    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should show cart" do
    get :show, id: @cart
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cart
    assert_response :success
  end

  test "should update cart" do
    patch :update, id: @cart, cart: {  }
    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should destroy cart" do
    assert_difference('Cart.count', -1) do
      session[:cart_id] = @cart.id
      delete :destroy, id: @cart
    end

    assert_redirected_to store_path
  end
end


// app/controller/line_items_controller.rb dosyası içinde aşağıdaki değişiklikler yapıldı

#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart,
          notice: 'Line item was successfully created.' }
        format.json { render action: 'show',
          status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
          status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
  #...
end


//  app/views/carts/show.html.erb dosyasında aşağıdaki değişiklikler yapıldı


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<!-- START_HIGHLIGHT -->
<h2>Your Cart</h2>
<table>
<!-- END_HIGHLIGHT -->
  <% @cart.line_items.each do |item| %>
<!-- START_HIGHLIGHT -->
    <tr>
      <td><%= item.quantity %>&times;</td>
      <td><%= item.product.title %></td>
      <td class="item_price"><%= number_to_currency(item.total_price) %></td>
    </tr>
<!-- END_HIGHLIGHT -->
  <% end %>

<!-- START_HIGHLIGHT -->
  <tr class="total_line">
    <td colspan="2">Total</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>
<!-- END_HIGHLIGHT -->
<!-- START_HIGHLIGHT -->
</table>
<!-- END_HIGHLIGHT -->

<%= button_to 'Empty cart', @cart, method: :delete,
    data: { confirm: 'Are you sure?' } %>


//  app/models/line_item.rb dosyasında aşağıdaki değişiklikler yapıldı

class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end
end

//  app/models/cart.rb dosyasında aşağıdaki değişiklikler yapıldı

class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end

//  app/assets/stylesheets/carts.css.scss dosyasında aşağıdaki değişiklikler yapıldı


// Place all the styles related to the Carts controller here.
// They will automatically be included in application.css.
// You can use Sass (SCSS) here: http://sass-lang.com/
/* START_HIGHLIGHT */
.carts {
  .item_price, .total_line {
    text-align: right;
  }
  .total_line .total_cell {
    font-weight: bold;
    border-top: 1px solid #595;
  }
}
/* END_HIGHLIGHT */


11.BÖLÜM

// app/views/carts/show.html.erb dosyasında aşağıdaki değişiklikler yapıldı

<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<!-- START_HIGHLIGHT -->
<h2>Your Cart</h2>
<table>
<!-- END_HIGHLIGHT -->
  <% @cart.line_items.each do |item| %>
<!-- START_HIGHLIGHT -->
    <tr>
      <td><%= item.quantity %>&times;</td>
      <td><%= item.product.title %></td>
      <td class="item_price"><%= number_to_currency(item.total_price) %></td>
    </tr>
<!-- END_HIGHLIGHT -->
  <% end %>

<!-- START_HIGHLIGHT -->
  <tr class="total_line">
    <td colspan="2">Total</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>
<!-- END_HIGHLIGHT -->
<!-- START_HIGHLIGHT -->
</table>
<!-- END_HIGHLIGHT -->

<%= button_to 'Empty cart', @cart, method: :delete,
    data: { confirm: 'Are you sure?' } %>


// app/views/carts/show.html.erb dosyasında aşağıdaki değişiklikler yapıldı

<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<h2>Your Cart</h2>
<table>
<!-- START_HIGHLIGHT -->
  <%= render(@cart.line_items) %>
<!-- END_HIGHLIGHT -->

  <tr class="total_line">
    <td colspan="2">Total</td>
    <td class="total_cell"><%= number_to_currency(@cart.total_price) %></td>
  </tr>

</table>

<%= button_to 'Empty cart', @cart, method: :delete,
    data: { confirm: 'Are you sure?' } %>

//  app/views/line_items/_line_item.html.erb dosyası oluştur ve içine aşağıdakiler ekle

<tr>
  <td><%= line_item.quantity %>&times;</td>
  <td><%= line_item.product.title %></td>
  <td class="item_price"><%= number_to_currency(line_item.total_price) %></td>
</tr>


//  app/views/carts/_cart.html.erb dosyası oluştur ve içine aşağıdakileri ekle


<h2>Your Cart</h2>
<table>
<!-- START_HIGHLIGHT -->
  <%= render(cart.line_items) %>
<!-- END_HIGHLIGHT -->

  <tr class="total_line">
    <td colspan="2">Total</td>
<!-- START_HIGHLIGHT -->
    <td class="total_cell"><%= number_to_currency(cart.total_price) %></td>
<!-- END_HIGHLIGHT -->
  </tr>

</table>

<!-- START_HIGHLIGHT -->
<%= button_to 'Empty cart', cart, method: :delete,
#END_HIGHLIGHT
    data: { confirm: 'Are you sure?' } %>

//  app/views/carts/show.html.erb dosyasında aşağıdaki gibi değişiklik yapıldı


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<!-- START_HIGHLIGHT -->
<%= render @cart %>
<!-- END_HIGHLIGHT -->

//  app/views/carts/_cart.html.erb dosyasında aşağıdaki gibi değişiklik yapılmıştır.


<h2>Your Cart</h2>
<table>
<!-- START_HIGHLIGHT -->
  <%= render(cart.line_items) %>
<!-- END_HIGHLIGHT -->

  <tr class="total_line">
    <td colspan="2">Total</td>
<!-- START_HIGHLIGHT -->
    <td class="total_cell"><%= number_to_currency(cart.total_price) %></td>
<!-- END_HIGHLIGHT -->
  </tr>

</table>

<!-- START_HIGHLIGHT -->
<%= button_to 'Empty cart', cart, method: :delete,
#END_HIGHLIGHT
    data: { confirm: 'Are you sure?' } %>

//  app/views/carts/show.html.erb dosyasında aşağıdaki gibi değişiklikler yapılmıştır

<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<!-- START_HIGHLIGHT -->
<%= render @cart %>
<!-- END_HIGHLIGHT -->


//  app/views/carts/_cart.html.erb dosyasında aşağıdaki değişiklikler yapıldı


<h2>Your Cart</h2>
<table>
<!-- START_HIGHLIGHT -->
  <%= render(cart.line_items) %>
<!-- END_HIGHLIGHT -->

  <tr class="total_line">
    <td colspan="2">Total</td>
<!-- START_HIGHLIGHT -->
    <td class="total_cell"><%= number_to_currency(cart.total_price) %></td>
<!-- END_HIGHLIGHT -->
  </tr>

</table>

<!-- START_HIGHLIGHT -->
<%= button_to 'Empty cart', cart, method: :delete,
#END_HIGHLIGHT
    data: { confirm: 'Are you sure?' } %>

//  app/views/carts/show.html.erb dosyasında aşağıdaki gibi değişiklikler yapılmıştır

<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<!-- START_HIGHLIGHT -->
<%= render @cart %>
<!-- END_HIGHLIGHT -->

//  app/views/carts/show.html.erb dosyasında aşağıdaki değişiklikler yapıldı


<% if notice %>
<p id="notice"><%= notice %></p>
<% end %>

<!-- START_HIGHLIGHT -->
<%= render @cart %>
<!-- END_HIGHLIGHT -->

//  app/views/layouts/application.html.erb dosyasında aşağıdaki değişiklikler yapılmıştır


<!-- START:head -->
<!DOCTYPE html>
<html>
<head>
  <title>Pragprog Books Online Store</title>
  <%= stylesheet_link_tag    "application", media: "all",
    "data-turbolinks-track" => true %>
  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
  <%= csrf_meta_tags %>
</head>
<!-- END:head -->
<body class="<%= controller.controller_name %>">
  <div id="banner">
    <%= image_tag("logo.png") %>
    <%= @page_title || "Pragmatic Bookshelf" %>
  </div>
  <div id="columns">
    <div id="side">
<!-- START_HIGHLIGHT -->
      <div id="cart">
        <%= render @cart %>
      </div>

<!-- END_HIGHLIGHT -->
      <ul>
        <li><a href="http://www....">Home</a></li>
        <li><a href="http://www..../faq">Questions</a></li>
        <li><a href="http://www..../news">News</a></li>
        <li><a href="http://www..../contact">Contact</a></li>
      </ul>
    </div>
    <div id="main">
      <%= yield %>
    </div>
  </div>
</body>
</html>


//  app/controllers/store_controller.rb dosyasında aşağıdaki değişiklikler yapıldı


#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
  end
end


//  app/assets/stylesheets/carts.css.scss dosyasında aşağıdaki değişiklikler yapıldı


class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
  end
end


//  app/assests/stylesheets/application.css.scss dosyasında aşağıdaki değişiklikler yapıldı


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

//#START:side
  #side {
    float: left;
    padding: 1em 2em;
    width: 13em;
    background: #141;

/* START_HIGHLIGHT */
    form, div {
      display: inline;
    }  
 
    input {
      font-size: small;
    }

    #cart {
      font-size: smaller;
      color:     white;

      table {
        border-top:    1px dotted #595;
        border-bottom: 1px dotted #595;
        margin-bottom: 10px;
      }
    }

/* END_HIGHLIGHT */
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
//#END:side
}


//  app/controllers/line_items_controller.rb dosyasında aşağıdaki değişiklikler yapıldı


#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.json { render action: 'show',
          status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors,
          status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
  #...
end