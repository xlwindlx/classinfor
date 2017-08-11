require 'roo'
require 'pry'

def is_i?(str)
  !!(str =~ /\A[-+]?[0-9]+\z/)
end

def hello
  script_folder_path = File.dirname(__FILE__)
  xlsx = Roo::Spreadsheet.open("#{script_folder_path}/seoul.xlsx")
  sheet = xlsx.sheet(0)

  buildings = sheet.column(2)
  departments = sheet.column(9)
  floors = sheet.column(3)
  numbers = sheet.column(4)
  capacities = sheet.column(8)

  rooms = []
  for i in 2...buildings.size do
    str = buildings[i].split('관')[0]
    rooms[i-2] = {
        building: (is_i?(str) ? str.to_i : 0),
        floor: (floors[i] == 'B1' ? -1 : floors[i].to_i),
        loc: (floors[i][0] == '0' ? floors[i][1] : floors[i]) + numbers[i],
        capacity: capacities[i].to_i,
        department: departments[i]
    }
  end
  return rooms
end
#binding.pry