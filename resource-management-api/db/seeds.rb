# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Organization.destroy_all
Organization.create!([
                       { name: :personal },
                       { name: :business },
                       { name: :"non-profit" },
                       { name: :government },
                       { name: :community },
                     ])
Rails.logger.info "Created #{Organization.count} Organizations"

Workgroup.destroy_all
Workgroup.create!([
                { name: :user },
                { name: :marketing },
                { name: :admin },
                { name: :engineering },
                { name: :hr },
              ])
