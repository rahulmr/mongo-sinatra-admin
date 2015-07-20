module MongoAdmin
  class App < Sinatra::Base

    get '/db/:database/:collection/:id' do
      @db_name = params['database']
      @collection_name = params['collection']
      @document_id = params['id']

      database = @db.connect(@db_name)
      collection = database[@collection_name]

      @document = collection.find({_id: @document_id}).first # BSON::Document

      slim :document
    end


    put '/db/:database/:collection/:id' do
      db_name         = params['database']
      collection_name = params['collection']
      document_id     = params['id']
      document        = params['document']

      # TODO: document is not valid
      document = JSON.load(document)

      database = @db.connect(db_name)
      collection = database[collection_name]

      document = collection.find({_id: document_id}).replace_one(document)

      flash[:info] = 'Document successfully updated.'

      redirect "/db/#{db_name}/#{collection_name}/#{document_id}"
    end

    delete '/db/:database/:collection/:id' do
      db_name         = params['database']
      collection_name = params['collection']
      document_id     = params['id']
      document        = params['document']

      database = @db.connect(db_name)
      collection = database[collection_name]

      document = collection.find({_id: document_id}).delete_one

      flash[:info] = 'Document successfully removed.'

      redirect "/db/#{db_name}/#{collection_name}"
    end

  end
end

