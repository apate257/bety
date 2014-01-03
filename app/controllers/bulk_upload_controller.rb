class BulkUploadController < ApplicationController

  def start_upload
  end

  private
  def read_data
    
    csvpath = session[:csvpath]
    
    csv = CSV.open(csvpath, { headers: true })
    csv.readline
    session[:headers] = @headers = csv.headers


    @data = csv

    @columns = Trait.columns
    @displayed_columns = @columns.select { |col| !['id', 'created_at', 'updated_at'].include?(col.name) }

  end

  public
  def display_csv_file

    if params["CSV file"]
      uploaded_io = params["CSV file"]
      file = File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb')
      file.write(uploaded_io.read)
      session[:csvpath] = file.path
    end

    begin
      read_data

      @data.read # force exception if not well formed
      @data.rewind #

    rescue CSV::MalformedCSVError => e
      @errors = e
    end

    respond_to do |format|
      format.html {
        if @errors
          render action: "start_upload"
        else
          render
        end
      }
    end
  end


  def map_data

    read_data

  end


  def confirm_data
    read_data

  end

end