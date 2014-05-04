# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
banks = Bank.create([{ name: 'Millenium Bim' }, { name: 'BCI' }, { name: 'Moza Banco' }])
participant = Participant.create(name: 'Admilson Cossa')
account = Account.create( number: '210309408' holder: participant, bank: banks.first)
financial_categories = FinancialCategory.create([{ name: 'Production' }, { name: 'Administration' }, { name: 'Comercial' }])