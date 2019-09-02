require "net/http"
require "json"

class VdoCipher
  @@version = '1.1.1'
  attr_reader :version

  def initialize(conf, version = '1.1.3')
    @key = conf[:clientSecretKey]
    @version = version
  end

  def play_code(id, attr="", theme="9ae8bbe8dd964ddc9bdb932cca1cb59a")
    return "key not set" if (@key == nil)

    url = URI.parse("https://dev.vdocipher.com/api/videos/#{id}/otp")

    header = { 'Content-Type': 'text/json', 'Authorization': "Apisecret #{@key}" }

    req = Net::HTTP::Post.new(url.request_uri, header)
    res = Net::HTTP.start(url.host, url.port, use_ssl:true) {|http|
          http.request(req)
    }

    if(res.code != "200")
      return 'Status code error: ' + res.code
    end

    otp = JSON.parse(res.body)
    if( otp['error'] == "No video found" )
      return "video not found"
    end

    # make the theme configurable
    div_id = Time.now.to_i

    embedcode = <<EOS
<div id="vdo#{div_id}"></div>
<script>
(function(v,i,d,e,o){v[o]=v[o]||{}; v[o].add = v[o].add || function V(a){
(v[o].d=v[o].d||[]).push(a);};if(!v[o].l) { v[o].l=1*new Date();
a=i.createElement(d); m=i.getElementsByTagName(d)[0]; a.async=1; a.src=e;
m.parentNode.insertBefore(a,m);}})(window,document,"script",
"https://player.vdocipher.com/playerAssets/1.6.10/vdo.js","vdo");
vdo.add({
  otp: "#{otp["otp"]}",
  playbackInfo: btoa(JSON.stringify({
    videoId: "#{id}"
  })),
  theme: "#{theme}",
  container: document.querySelector( "#vdo#{div_id}" ),
});
</script>
EOS
    embedcode
  end
end