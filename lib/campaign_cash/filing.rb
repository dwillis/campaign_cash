module CampaignCash
  class Filing < Base

    attr_reader :committee_name, :date_coverage_from, :amended_uri, :fec_uri, :date_coverage_to, :committee, :report_title, :amended, :date_filed,
  :cycle, :form_type, :original_filing, :original_uri, :paper, :committee_type, :filing_id, :receipts_total, :disbursements_total, :cash_on_hand,
  :is_amendment

    def initialize(params={})
      params.each_pair do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    def self.create(params={}, name=nil)
      self.new date_coverage_from: date_parser(params['date_coverage_from']),
      date_coverage_to: date_parser(params['date_coverage_to']),
      date_filed: date_parser(params['date_filed']),
      committee: parse_committee(params['committee']),
      report_title: params['report_title'].strip,
      fec_uri: params['fec_uri'],
      amended: params['amended'],
      amended_uri: params['amended_uri'],
      original_filing: params['original_filing'],
      original_uri: params['original_uri'],
      paper: params['paper'],
      form_type: params['form_type'],
      filing_id: params['filing_id'],
      committee_type: Committee.get_committee_type(params['committee_type']),
      committee_name: params['committee_name'],
      receipts_total: params['receipts_total'],
      contributions_total: params['contributions_total'],
      disbursements_total: params['disbursements_total'],
      cash_on_hand: params['cash_on_hand'],
      is_amendment: params['is_amendment']
    end

    def self.today(offset=nil)
      cycle=CURRENT_CYCLE
      reply = Base.invoke("#{cycle}/filings", {offset: offset})
      results = reply['results']
      results.map{|c| Filing.create(c)}
    end

    def self.date(year, month, day, offset=nil)
      cycle = cycle_from_date(Date.strptime("#{month}/#{day}/#{year}", '%m/%d/%Y'))
        reply = Base.invoke("#{cycle}/filings/#{year}/#{month}/#{day}", {offset: offset})
        results = reply['results']
      results.map{|c| Filing.create(c)}
    end

    def self.form_types
      cycle=CURRENT_CYCLE
      reply = Base.invoke("#{cycle}/filings/types",{})
      results = reply['results']
      results.map{|ft| OpenStruct.new({id: ft['id'], name: ft['name'].strip})}
    end

    def self.amendments(offset=nil)
      cycle=CURRENT_CYCLE
      reply = Base.invoke("#{cycle}/filings/amendments", {offset: offset})
      results = reply['results']
      results.map{|c| Filing.create(c)}
    end

    def self.by_type(cycle, form_type)
      reply = Base.invoke("#{cycle}/filings/types/#{form_type}")
        results = reply['results']
      results.map{|c| Filing.create(c)}
    end
  end
end
