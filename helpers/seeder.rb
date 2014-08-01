class Tools
  def self.seed_db #Update all of the database, adding new entries if needed.
    client = Octokit::Client.new(:access_token => KEYS[:GithubToken])
    response = client.search_repos("library language:Rust")
  end
end

