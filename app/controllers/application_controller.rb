class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  #決まった英語を日本語に変換する関数
  #return 日本語訳
  def translateSceneToJP(text_en)
    translate_hash = {}
    translate_hash["Urban"] = "都会"
    translate_hash["Beach"] = "海辺"
    translate_hash["Water"] = "水"
    translate_hash["Restaurant"] = "nレストラン"
    translate_hash["Night Life"] = "夜景"
    translate_hash["Food"] = "n食事"
    translate_hash["Indoor"] = "屋内"
    translate_hash["Suburban"] = "郊外"
    translate_hash["Snow"] = "雪"
    translate_hash["River"] = "川"
    translate_hash["Rock Climbing"] = "山登り"
    translate_hash["Ocean"] = "海"
    translate_hash["Park"] = "公園"
    translate_hash["Sunset"] = "夕日"
    translate_hash["Desert"] = "荒れ地"
    translate_hash["Mountain"] = "山地"

    text_jp = ""

    if translate_hash.has_key?(text_en) == true
      text_jp = translate_hash[text_en]
      if text_jp.include?("n") == true
        text_jp = ""
      end
    end
    puts text_en
    puts text_jp
    return text_jp
  end
end
