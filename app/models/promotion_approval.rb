class PromotionApproval < ApplicationRecord
  belongs_to :promotion
  belongs_to :user

  validate :creator_other_than_approver

  private
  def creator_other_than_approver
    if promotion && promotion.user == user
      errors.add(:user, 'usuário criador da promoção não pode ser o aprovador')
    end
  end

end
