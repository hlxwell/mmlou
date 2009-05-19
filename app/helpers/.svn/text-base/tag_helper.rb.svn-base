module TagHelper
  ### getTagFirstPhoto ###################
  def getTagCoverUrl(tag)
    cover = tag.cover
    if cover
      return "<img src=#{getThumbImageUrl(cover)} />"
    else
      return "Tag <b>#{tag}</b> #{l('problem_label_noRelatedPhoto')}"
    end
  end
  
  #照片Tag大小
  def getTagSizeByPhotoNum(num)
    if num>150
      return "huge"
    elsif num<150 and num>100
      return "big"
    elsif num<100 and num>50
      return "middle"
    elsif num<50 and num>20
      return "small"
    else
      return ""
    end
  end
  
  #相册Tag大小
  def getTagSizeByAlbumNum(num)
    if num>10
      return "huge"
    elsif num<10 and num>5
      return "big"
    elsif num<5 and num>2
      return "middl"
    elsif num<2 and num>0
      return "small"
    else
      return ""
    end
  end
end
