class StaticPagesController < ApplicationController

  def home
    @news = News.order(created_at: :desc).take(8)
    @programs = Program.order(created_at: :desc).take(8)
    @notify = News.where(notify: true).order(created_at: :desc).first
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

  def live
    $dota2_live_list = {}
    $dota2_live_list_sort = {}
    $label = {'douyu' => 'warning','zhanqi' => 'primary','huomao' => 'danger'}
    $color = {'douyu' => '#f0ad4e','zhanqi' => '#428bca','huomao' => '#d9534f'}

    # $dota2_anchor_intro = YAML.load(File.open('config/dota2_anchor_intro.yml'))

    $dota2_anchor_intro = {
      'zhanqi.lgd_mmy' => ['MMY','lgd.MMY'],
      'zhanqi.Burning' => ['Burning','Burning'],
      'douyu.IG430' => ['430','iG.430'],
      'huomao.lanm2014' => ['lanm','lanm'],
      'douyu.Pc冷冷' => ['冷冷','Dota2解说'],
      'douyu.igchuan' => ['ChuaN','iG.ChuaN'],
      'huomao.Oo老队长rOtK' => ['rOtK','rOtK'],
      'douyu.张宁_xiao8' => ['xiao8','xiao8'],
      'douyu.mushichai' => ['MuShi','EHOME.MuShi'],
      'douyu.yyfyyf' => ['YYF', 'RPG天团成员'],
      'douyu.a274951686' => ['KINGJ','KINGJ'],
      'douyu.luoyinqi' => ['Luo','iG.Luo'],
      'douyu.hyrx105' => ['HyrX','HyrX'],
      'douyu.ImbaTV直播' => ['ImbaTV','ImbaTV'],
      'douyu.hyhy汉勇' => ['HYHY','HYHY'],
      'douyu.waterater' => ['沐沐','Dota2解说'],
      'douyu.念念Misa' => ['念念','Dota2解说'],
      'zhanqi.sjq老鼠' => ['鼠大王','鼠大王'],
      'zhanqi.lilith♥' => ['lilith','lilith'],
      'zhanqi.lgd_yao' => ['Yao','lgd.Yao'],
      'huomao.NewBeeTV' => ['NewBeeTV','NewBeeTV'],
      'huomao.VG.Black' => ['Black','vg.Black'],
      'huomao.VG.fyfy' => ['fy','vg.fy'],
      'huomao.赵洁Leah' => ['赵洁','赵洁'],
      'huomao.yanghanna' => ['Yang Hanna','Yang Hanna'],
      'zhanqi.伍声 2009' => ['2009','前DOTA职业选手, 现任电竞视频解说, 淘宝卖家'],
      'huomao.MarsTV官方' => ['MarsTV','MarsTV官方'],
      'huomao.MarsTV官方频道2' => ['MarsTV2','MarsTV官方频道2'],
      'huomao.LV妖精Zyf' => ['妖精','EHOME.妖精'],
      'huomao.inflamelol' => ['Inflame','EHOME.Inflame'],
      'huomao.LGDTV直播间' => ['LGDTV','LGDTV是LGD电子竞技俱乐部旗下专业赛事直播平台'],
      'huomao.huomaoTV官方' => ['huomaoTV','huomaoTV官方'],
      'huomao.huomaoTV官方2' => ['huomaoTV2','huomaoTV官方2'],
      'huomao.雅少萌萌哒' => ['陈雅','Dota2解说'],
      'huomao.NWP' => ['YamateH','Y神'],
      'huomao.教练mikasa' => ['教练','cdec.mikasa'],
      'huomao.VG.super' => ['super','vg.super'],
      'zhanqi.安娜萌萌哒✿' => ['安娜','安娜萌萌哒✿'],
      'zhanqi.Yomi丶酸奶' => ['Yomi丶酸奶','Yomi丶酸奶'],
      'zhanqi.✿﹏Yuno酱' => ['✿﹏Yuno酱','✿﹏Yuno酱'],
      'zhanqi.lgd_Sylar' => ['Sylar','lgd.sylar'],
      'zhanqi.lgd_Faith' => ['Faith','lgd.Faith'],
      'zhanqi.lgd_injuly' => ['injuly','lgd.injuly'],
      'zhanqi.傻瓜立' => ['li','Newbee.Li'],
      'zhanqi.Newbee_Banana' => ['Banana','Newbee.Banana'],
      'zhanqi.Newbee_Hao' => ['Hao','Newbee.Hao'],
      'zhanqi.Newbee_Mu' => ['Mu','Newbee.Mu'],
      'zhanqi.Newbee_SanSheng' => ['SanSheng','Newbee.SanSheng'],
      'zhanqi.王章' => ['Rabbit','Newbee.Rabbit'],
      'douyu.ctyzzz' => ['Cty','DK.Cty'],
      'douyu.杰出哥' => ['杰出','斗鱼解说'],
      'douyu.stormall' => ['HGT','HGT直播'],
      'douyu.ZSMJ727974758' => ['ZSMJ','HGT.ZSMJ'],
      'douyu.452123262' => ['陈世美','HGT.kaka'],
    }

    update_dota2_live_list
    $dota2_update_time = Time.zone.now.getlocal

    if Time.now - $dota2_update_time > 30
      $dota2_live_list.clear
      $dota2_live_list_sort.clear
        update_dota2_live_list
      $dota2_update_time = Time.now.getlocal("+08:00")
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

      agent.get(zhanqi_dota2_url).search('//*[@id="hotList"]/li').each do |list|
        break if list.search('i').text == '休息'
        key = zhanqi + '.' + list.search('a.anchor').text
        view = list.search('span.dv').text
        $dota2_live_list[key] = {
          :site => zhanqi,
          :img => list.search('img').attr('src').text,
          :href => zhanqi_url + list.search('a').attr('href').text,
          :title => list.search('a.name').text,
          :nnt => list.search('a.anchor').text,
          :view => view,
          :zbName => list.search('a.game-name').text
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
