require "net/http"
require "json"
class VdoCipher
	def initialize(conf)
		@key = conf[:clientSecretKey]
	end
	def play_code(id, attr="")
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
		embedcode = <<EOS
<div id="vdo%s" %s></div>
<script>
	(function(v,i,d,e,o){v[o]=v[o]||{}; v[o].add = v[o].add || function V(a){ (v[o].d=v[o].d||[]).push(a);};
	 if(!v[o].l) { v[o].l=1*new Date(); a=i.createElement(d), m=i.getElementsByTagName(d)[0];
	 a.async=1; a.src=e; m.parentNode.insertBefore(a,m);}
	})(window,document,"script","//de122v0opjemw.cloudfront.net/vdo.js","vdo");
	vdo.add({o: "%s"});
</script>
EOS
		embedcode = embedcode % [otp["otp"], attr, otp["otp"]]
	end
end

