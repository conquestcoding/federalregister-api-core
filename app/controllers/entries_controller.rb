class EntriesController < ApplicationController
  def widget
    cache_for 1.day
    params[:per_page] = 5
    params[:order] = :date
    @search = EntrySearch.new(params)
    
    render :layout => 'widget'
  end
  
  def index
    cache_for 1.day
    respond_to do |wants|
      wants.html do
        redirect_to entries_by_date_path(Entry.latest_publication_date)
      end
      wants.rss do
        @feed_name = 'Federal Register Latest Entries'
        @entries = Entry.find(:all, :conditions => {:publication_date => Entry.latest_publication_date})
      end
    end
  end
  
  def date_search
    date = Chronic.parse(params[:search], :context => :past)
    raise ActiveRecord::RecordNotFound if date.nil?
    redirect_to entries_by_date_url(date)
  end
  
  def by_date
    cache_for 1.day
    
    @year  = params[:year]  || Time.now.strftime("%Y")
    @month = params[:month] || Time.now.strftime("%m")
    @day   = params[:day]   || Time.now.strftime("%d")
    @publication_date = Date.parse("#{@year}-#{@month}-#{@day}")
    
    @agencies = Agency.all(
      :include => [:entries],
      :conditions => ['publication_date = ?', @publication_date],
      :order => "agencies.name, entries.title"
    )
    
    Agency.preload_associations(@agencies, :children)
    Entry.preload_associations(@agencies.map(&:entries).flatten, :agencies)
    
    @agencies.each do |agency|
      def agency.entries_excluding_subagency_entries
        self.entries.select{|entry| entry.agencies_excluding_parents.include?(self) }
      end
    end
    
    @entries_without_agency = Entry.all(
      :include => :agencies,
      :conditions => ['agencies.id IS NULL && entries.publication_date = ?', @publication_date],
      :order => "entries.title"
    )
    
    if @agencies.blank? && @entries_without_agency.blank?
      raise ActiveRecord::RecordNotFound
    end
    
  end
  
  def show
    cache_for 1.day
    @entry = Entry.find_by_document_number!(params[:document_number])
    
    respond_to do |wants|
      wants.html      
      wants.xml do
        send_file @entry.full_xml_file_path, :filename => "#{@entry.document_number}.xml"
      end
    end
  end
  
  def citations
    cache_for 1.day
    @entry = Entry.find_by_document_number!(params[:document_number])
  end
  
  def tiny_url
    cache_for 1.day
    entry = Entry.find_by_document_number!(params[:document_number])
    url = entry_url(entry)
    
    if params[:anchor].present?
      url += '#' + params[:anchor]
    end
    
    redirect_to url, :status=>:moved_permanently
  end
end