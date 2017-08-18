class EmptyRoomController < ApplicationController
  def home
    @data = {}
    # 지금 필요한게 뭐야?
    #각 건물별 층 정보가 필요해
    ##그러면 뭘해야하하지
    #층을 키로 가지고 array로
    Building.all.order(number: :asc).each do |b|
      @data[b.number.to_s] = b.have_floors
    end
  end

  private
  def makefloors

  end
end
