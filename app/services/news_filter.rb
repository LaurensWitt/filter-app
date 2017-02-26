class NewsFilter
  include ActiveModel::Model
  attr_accessor :per_page
  attr_accessor :preferred
  attr_accessor :blacklisted
  attr_accessor :page
  attr_accessor :categories

  def news_items
    @news_items = NewsItem.sorted.includes(:categories, :source).limit(@limit).page(@page)
    apply_filter!
    apply_order!
    @news_items
  end

  def apply_order!
    ranking = "news_items.value * (#{boost})"
    @news_items = @news_items.visible.select("news_items.*, #{ranking} as current_score")
    @news_items = @news_items.reorder!('current_score desc')
  end

  def apply_filter!
    if @blacklisted.present?
      @news_items = @news_items.where.not(source_id: escape(@blacklisted))
    end
    if @categories.present?
      @news_items = @news_items.where(%{news_items.id in (
                                      select news_item_id from categories_news_items
                                      where news_item_id = news_items.id and
                                            category_id in (#{escape(@categories).join(',')})
                                      )})
    end
  end

  def boost
    if @preferred.present?
      s = @preferred.split(',').map(&:to_i).join(',')
      "case when source_id in (#{s}) then 2 when true then 1 end"
    else
      '1'
    end
  end

  def escape(string_array)
    string_array.split(',').map(&:to_i)
  end
end