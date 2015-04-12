class StaticPagesController < ApplicationController

  def home
    t1 = Thread.new do
      dota2live
    end
    t2 = Thread.new do
      hslive
    end
    t3 = Thread.new do
      dota2gusolist
    end
    t1.join(8)
    t2.join(8)
    t3.join(8)
    @news = News.order(created_at: :desc).take(16)
    @programs = Program.order(created_at: :desc).take(16)
    @notify = News.where(notify: true).order(created_at: :desc).first
    unless @notify.nil?
      if @news.include?(@notify)
        @news.delete(@notify)
        @news.unshift(@notify)
      else
        @news.unshift(@notify)
        @news.pop
      end
    end
  end

  def dota2gusolist
    if $dota2_guso_update_time.nil? || (Time.zone.now.getlocal - $dota2_guso_update_time > 172)
      begin
        $dota2_guso_list = []
        update_dota2_guso_list
      rescue Exception => e
        nil
      end
    end
  end

  def update_dota2_guso_list
    agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      agent.max_file_buffer = 10000000
    end
    agent.get('http://www.gosugamers.net/dota2').search('#gb-matches tr').each do |list|
      opp1 = list.search('.opp1 span').last.text
      opp2 = list.search('.opp2 span').last.text
      status = list.search('.status span').last.text.sub('h', '小时').sub('m', '分').sub('s', '秒').sub('Live', '进行中')
      $dota2_guso_list << {opp1: opp1, opp2: opp2, status: status}
    end
    $dota2_guso_update_time = Time.zone.now.getlocal
  end

  def login
    if is_admin?(params[:admin][:password])
      admin_login
      redirect_to request.referrer
    else
      redirect_to request.referrer
    end
  end

  def logout
    admin_logout
    redirect_to request.referrer
  end

  def ileague
  end

  def dac
  end

  def dota2live
    if $dota2_update_time.nil?
      $dota2_live_list = {}
      $dota2_live_list_sort = {}
      $label = {'douyu' => 'warning','zhanqi' => 'primary','huomao' => 'danger'}
      $color = {'douyu' => '#f0ad4e','zhanqi' => '#428bca','huomao' => '#d9534f'}

      $dota2_anchor_intro = {}
      update_dota2_live_list
      $dota2_update_time = Time.zone.now.getlocal
    end

    if Time.now - $dota2_update_time > 58
      $dota2_live_list.clear
      $dota2_live_list_sort.clear
      update_dota2_live_list
      $dota2_update_time = Time.zone.now.getlocal
    end

  end

  def hslive
    if $hs_update_time.nil?
      $hs_live_list = {}
      $hs_live_list_sort = {}
      $label = {'douyu' => 'warning','zhanqi' => 'primary','huomao' => 'danger'}
      $color = {'douyu' => '#f0ad4e','zhanqi' => '#428bca','huomao' => '#d9534f'}

      $hs_anchor_intro = {}
      update_hs_live_list
      $hs_update_time = Time.zone.now.getlocal
    end

    if Time.now - $hs_update_time > 58
      $hs_live_list.clear
      $hs_live_list_sort.clear
      update_hs_live_list
      $hs_update_time = Time.zone.now.getlocal
    end

  end

  private

  def update_dota2_live_list

    douyu = 'douyu'
    zhanqi = 'zhanqi'
    huomao = 'huomao'
    douyu_url = 'http://www.douyutv.com'
    zhanqi_url = 'http://www.zhanqi.tv'
    huomao_url = 'http://www.huomaotv.com'
    douyu_dota2_url = 'http://www.douyutv.com/directory/game/DOTA2'
    zhanqi_dota2_url = 'http://www.zhanqi.tv/games/dota2'
    huomao_dota2_url = 'http://www.huomaotv.com/live_list?gid=23'

    agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      agent.max_file_buffer = 10000000
    end

    begin
      agent.get(douyu_dota2_url).search('//*[@id="item_data"]/ul/li').each do |list|
        key = douyu + '.' + list.search('span.nnt').text
        view = list.search('span.view').text
        $dota2_live_list[key] = {
          :site => douyu,
          :img => list.search('img').attr('data-original').text,
          :href => douyu_url + list.search('a').attr('href').text,
          :title => list.search('a').attr('title').text,
          :nnt => list.search('span.nnt').text,
          :view => view,
          :zbName => list.search('span.zbName').text
        }
        $dota2_live_list_sort[view.include?('万') ? view.to_f * 10000 + rand(100) : view.to_f] = key
      end

      agent.get(zhanqi_dota2_url).search('#hotList li').each do |list|
        break if list.search('i').text == '休息'
        key = zhanqi + '.' + list.search('span.anchor').text
        view = list.search('span.views span').text
        $dota2_live_list[key] = {
          :site => zhanqi,
          :img => list.search('img').attr('src').text,
          :href => zhanqi_url + list.search('a').attr('href').text,
          :title => list.search('span.name').text,
          :nnt => list.search('span.anchor').text,
          :view => view,
          :zbName => list.search('span.game-name').text
        }
        $dota2_live_list_sort[view.include?('万') ? view.to_f * 10000 + rand(100) : view.to_f] = key
      end

      agent.get(huomao_dota2_url).search('//*[@id="live_list"]/div').each do |list|
        break if list.search('.up_offline').text == '主播正在休息'
        key = huomao + '.' + list.search('.LiveAuthor').text
        view = list.search('.fans').text
        $dota2_live_list[key] = {
          :site => huomao,
          :img => huomao_url + list.search('img').attr('src').text,
          :href => huomao_url + list.search('.play_btn').attr('href').text,
          :title => list.search('.VOD_title > dt > a').text,
          :nnt => list.search('.LiveAuthor').text,
          :view => view,
          :zbName => list.search('.titleMb').text[0, 5]
        }
        $dota2_live_list_sort[view.include?('万') ? view.to_f * 10000 + rand(100) : view.to_f] = key
      end
    end
  end

  def update_hs_live_list

    douyu = 'douyu'
    zhanqi = 'zhanqi'
    huomao = 'huomao'
    douyu_url = 'http://www.douyutv.com'
    zhanqi_url = 'http://www.zhanqi.tv'
    huomao_url = 'http://www.huomaotv.com'
    douyu_hs_url = 'http://www.douyutv.com/directory/game/How'
    zhanqi_hs_url = 'http://www.zhanqi.tv/games/how'
    huomao_hs_url = 'http://www.huomaotv.com/live_list?gid=13'

    agent = Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
      agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      agent.max_file_buffer = 10000000
    end
    begin
      agent.get(douyu_hs_url).search('//*[@id="item_data"]/ul/li').each do |list|
        key = douyu + '.' + list.search('span.nnt').text
        view = list.search('span.view').text
        $hs_live_list[key] = {
          :site => douyu,
          :img => list.search('img').attr('data-original').text,
          :href => douyu_url + list.search('a').attr('href').text,
          :title => list.search('a').attr('title').text,
          :nnt => list.search('span.nnt').text,
          :view => view,
          :zbName => list.search('span.zbName').text
        }
        $hs_live_list_sort[view.include?('万') ? view.to_f * 10000 + rand(100) : view.to_f] = key
      end

      agent.get(zhanqi_hs_url).search('#hotList li').each do |list|
        break if list.search('i').text == '休息'
        key = zhanqi + '.' + list.search('span.anchor').text
        view = list.search('span.views span').text
        $hs_live_list[key] = {
          :site => zhanqi,
          :img => list.search('img').attr('src').text,
          :href => zhanqi_url + list.search('a').attr('href').text,
          :title => list.search('span.name').text,
          :nnt => list.search('span.anchor').text,
          :view => view,
          :zbName => list.search('span.game-name').text
        }
        $hs_live_list_sort[view.include?('万') ? view.to_f * 10000 + rand(100) : view.to_f] = key
      end

      agent.get(huomao_hs_url).search('//*[@id="live_list"]/div').each do |list|
        break if list.search('.up_offline').text == '主播正在休息'
        key = huomao + '.' + list.search('.LiveAuthor').text
        view = list.search('.fans').text
        $hs_live_list[key] = {
          :site => huomao,
          :img => huomao_url + list.search('img').attr('src').text,
          :href => huomao_url + list.search('.play_btn').attr('href').text,
          :title => list.search('.VOD_title > dt > a').text,
          :nnt => list.search('.LiveAuthor').text,
          :view => view,
          :zbName => list.search('.titleMb').text[0, 5]
        }
        $hs_live_list_sort[view.include?('万') ? view.to_f * 10000 + rand(100) : view.to_f] = key
      end
    end
  end

end
