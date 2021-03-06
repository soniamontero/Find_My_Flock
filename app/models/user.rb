class User < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  mount_uploader :resume_file_path, PdfUploader

  belongs_to :registration
  has_many :applications, :dependent => :destroy
  has_many :favorites, :dependent => :destroy

  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update

  acts_as_taggable_on :skills, :values, :salaries, :locations

  def add_tags(tags)
    self.salary_list = tags["salaries"].compact
    self.save!
    self.value_list = tags["values"]
    self.save!
    save_locations(tags["locations"])
    self.save!
    save_skills(tags["skills"])
  end

  def clean_skill(skill)
    skill.to_s.split(/\d/).first
  end

  def text_skills
    self.skills.map { |skill| clean_skill(skill) }.uniq
  end

  def save_locations(locations)
    delete_locations
    locations.each do |location|
      self.location_list.add(location, parse: false)
    end
  end

  def save_skills(skills)
    skills.each do |skill|
      i = skill.slice(-1).to_i
      temp_skill = skill
      while i > 1 do
        temp_skill = "#{skill.chop}#{(i-1).to_s}"
        skills << temp_skill
        i -= 1
      end
    end
    self.skill_list = skills
    self.save!
  end

  def delete_locations
    self.location_list.remove(self.location_list)
  end

  def competency_description(selection)
    competencies = ["Only a little knowledge", "Gaining competency", "Individual competency", "Strong competency", "Expert"]
    return competencies[selection]
  end

  def skills_competencies
    competencies = ["Only a little knowledge", "Gaining competency", "Individual competency", "Strong competency", "Expert"]
    num_hash = return_skills_hash
    new_hash = {}
    num_hash.each { |language, skill| new_hash[language] = competencies[skill -1] }
    new_hash
  end

  def return_skills_hash
    upcased_array = self.skill_list.map(&:upcase)
    new_hash = {}
    array_of_hash = upcased_array.map do |element|
      index_num = element.index(/\d/)
      if !index_num.nil?
        language = element[0...index_num]
        skill_level = element[index_num..-1].to_i
        if new_hash[language]
          new_hash[language] = skill_level if new_hash[language] < skill_level
        else
          new_hash[language] = skill_level.to_i
        end
      else
        new_hash[element] = 1
      end
    end
    new_hash
  end
end
























