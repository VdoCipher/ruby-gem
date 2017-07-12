require "net/http"
require "json"
class VdoCipher
	def initialize(conf)
		@key = conf[:clientSecretKey]
	end
	def play_code(id, attr="", theme="9ae8bbe8dd964ddc9bdb932cca1cb59a")
		if (@key == nil)
			return "key not set"
		end
		url = URI.parse('https://api.vdocipher.com/v2/otp?video='+ id)
		req = Net::HTTP::Post.new(url.to_s)
		req.body = 'clientSecretKey=' + @key
		res = Net::HTTP.start(url.host, url.port, use_ssl:true) {|http|
					http.request(req)
		}
		if(res.code != "200")
			return res.code
		end
		otp = JSON.parse(res.body)
		if( otp['error'] == "No video found" )
			return "video not found"
		end
    # make the theme configurable
		embedcode = <<EOS
<div id="vdo%s" %s></div>
<script>
(function(v,i,d,e,o){v[o]=v[o]||{}; v[o].add = v[o].add || function V(a){ (v[o].d=v[o].d||[]).push(a);};
if(!v[o].l) { v[o].l=1*new Date(); a=i.createElement(d), m=i.getElementsByTagName(d)[0];
a.async=1; a.src=e; m.parentNode.insertBefore(a,m);}
})(window,document,"script","https://d1z78r8i505acl.cloudfront.net/playerAssets/vdo.js","vdo");
vdo.add({
  otp: "%s",
  playbackInfo: btoa(JSON.stringify({
    videoId: "%s"
  })),
  theme: "%s",
  container: document.querySelector( "#vdo%s" ),
});
</script>

EOS
		embedcode = embedcode % [otp["otp"], attr, otp["otp"], id, theme, otp["otp"]]
	end
end

