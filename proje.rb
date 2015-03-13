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


