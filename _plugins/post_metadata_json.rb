require "json"

module Jekyll
  class PostMetadataJsonPage < PageWithoutAFile
    def initialize(site, post)
      @site = site
      @base = site.source
      @dir = post.url.sub(%r!^/!, "").sub(%r!/+$!, "")
      @name = "metadata.json"
      process(@name)
      self.data = { "layout" => nil, "sitemap" => false }
      self.content = JSON.pretty_generate(ScholarlyMetadata.graph(post.to_liquid, site))
    end
  end

  class PostMetadataJsonGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.posts.docs.each do |post|
        next if post.data["published"] == false
        site.pages << PostMetadataJsonPage.new(site, post)
      end
    end
  end
end
