  # frozen_string_literal: true
  class HomeController < ShopifyApp::AuthenticatedController
    layout "application"
    require 'csv'

    def index
      @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
      @webhooks = ShopifyAPI::Webhook.find(:all)
    end

    def pages
      @pages = ShopifyAPI::Page.find(:all, params: { limit: 250 })
      @pages.each do |page|
        page_tmp = ShopifyAPI::Page.new(page.attributes)
        page_tmp.old_id = page_tmp.id
        page_tmp.shop_id = nil
        page_tmp.id = nil
        page_tmp.save
        sleep(0.5)
      end
    end

    def products_from_csv
      url_csv = '/Users/thomas/Desktop/pb_pro.csv'
      table = CSV.parse('/Users/thomas/Desktop/pb_pro.csv', headers: true)
      table[0]

      CSV.open('/Users/thomas/Desktop/pb_products.csv', 'r') do |row|
        p row
      end

      filename = '/Users/thomas/Desktop/pppp.csv'
      file = File.new(filename, 'r')
      file.each_line("\n") do |row|
        p row
        row = row.gsub(/"/,'').split(';')
        p row

        images = []
        row[1].split(',').each {|img| images.push({"src": img})}
        p images
        pro = ShopifyAPI::Product.new({
          "title": row[2],
          "tags": row[4],
          "price": row[6],
          "available": row[8],
          "description": 'Description',
          "images": images
        })
        p pro
        pro.save
        sleep(0.5)
      end



      @pages = ShopifyAPI::Page.find(:all, params: { limit: 250 })
      @pages.each do |page|
        page_tmp = ShopifyAPI::Page.new(page.attributes)
        page_tmp.old_id = page_tmp.id
        page_tmp.shop_id = nil
        page_tmp.id = nil
        page_tmp.save
        sleep(0.5)
      end
    end

  end

