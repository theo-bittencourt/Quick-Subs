#encoding=utf-8

class SubtitlesController < ApplicationController
  before_filter :admin?, :except => :download

  # GET /subtitles
  # GET /subtitles.json
  def index
    @subtitles = Subtitle.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @subtitles }
    end
  end
  
  # GET /subtitles/1
  # GET /subtitles/1.json
  def show
    @subtitle = Subtitle.find(params[:id])
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @subtitle }
    end
  end

  # GET /subtitles/new
  # GET /subtitles/new.json
  def new
    @subtitle = Subtitle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subtitle }
    end
  end

  # GET /subtitles/1/edit
  def edit
    @subtitle = Subtitle.find(params[:id])
  end

  # POST /subtitles
  # POST /subtitles.json
  def create
    @subtitle = Subtitle.new(params[:subtitle])

    respond_to do |format|
      if @subtitle.save
        format.html { redirect_to @subtitle, notice: 'Subtitle was successfully created.' }
        format.json { render json: @subtitle, status: :created, location: @subtitle }
      else
        format.html { render action: "new" }
        format.json { render json: @subtitle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subtitles/1
  # PUT /subtitles/1.json
  def update
    @subtitle = Subtitle.find(params[:id])

    respond_to do |format|
      if @subtitle.update_attributes(params[:subtitle])
        format.html { redirect_to @subtitle, notice: 'Subtitle was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @subtitle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subtitles/1
  # DELETE /subtitles/1.json
  def destroy
    @subtitle = Subtitle.find(params[:id])
    @subtitle.destroy

    respond_to do |format|
      format.html { redirect_to subtitles_url }
      format.json { head :ok }
    end
  end

  def download
    respond_to do |format|
      # download one subtitle
      if subtitle = LtvApi.baixar(params[:id], :name => params[:name])
        format.html {
          send_data(
            subtitle[:body],
            :type => subtitle[:content_type], 
            :filename => subtitle[:name]
          )
        }
       
      # download a pack  
      elsif pack_full_path = LtvApi.baixar_pack(params[:subs])
        format.html {
          send_file(pack_full_path, :type => 'application/zip')
        }

      else
        redirect_to :back, :notice => "Ocorreu um problema e não foi possível realizar o download."
      end
    end
  end

end
