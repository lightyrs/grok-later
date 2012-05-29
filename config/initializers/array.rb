class Array
  
  def sort_by_item_freq
  	uniq.sort_by{ |x| grep(x).size }.reverse
  end
 end