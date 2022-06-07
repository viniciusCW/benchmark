class TaskController < ApplicationController
require "benchmark"
require 'batch_jaro_winkler'
  #Agora tem que fazer os arrays e as comparações
  def initialize
    @merchants = []
    @terrorists = []

    @suspects = []
    @no_suspects = []
  end

  def execute
    set_up_db('db/merchants/merchants.json', Merchant)
    set_up_db('db/merchants/MOCK_DATA.json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (2).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (3).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (4).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (5).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (6).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (7).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (8).json', Merchant)
    set_up_db('db/merchants/MOCK_DATA (9).json', Merchant)

    set_up_db('db/terrorists.json', Terrorist)

    puts Benchmark.measure{
      set_up_merchant_data_arrays()
      set_up_terrorists_data_arrays()
  
      compare_names()
    }
    debugger
  end

  def set_up_db(file, classe)
    a = JSON.parse(File.read(file))

    a.each do |x|
      classe.create(x)
    end
  end

  def set_up_merchant_data_arrays
    Merchant.all.find_each do |x|
      register = {
        user_id: x.user_id,
        legal_representative_name: x.legal_representative_name,
      }

      @merchants.push(register)
    end
  end

  def set_up_terrorists_data_arrays
    Terrorist.all.find_each do |x|
      register = x.name

      @terrorists.push(register)
    end
  end

  def compare_names
    exportable_model = BatchJaroWinkler.build_exportable_model(@terrorists, nb_runtime_threads: 4) #["fulano", "cicrano", ...]
    runtime_model = BatchJaroWinkler.build_runtime_model(exportable_model)

    @merchants.each do |merchant|
      matches = BatchJaroWinkler.jaro_winkler_distance(runtime_model, merchant[:legal_representative_name], min_score: 0.9) #[["fulano", 0.9], [..]]

      if matches.empty?
        @no_suspects.append(merchant)
        Log.create({user_id: merchant[:user_id],
                    merch_name: merchant[:legal_representative_name],
                    suspect: false}
          )
      else
        register = merchant.clone
        register[:matches] = matches
        @suspects.append(register)

        Log.create({user_id: merchant[:user_id],
                    merch_name: merchant[:legal_representative_name],
                    suspect: true,
                    matches: matches}
        )
      end
    end
  end
end
