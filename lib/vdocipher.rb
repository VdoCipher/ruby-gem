require "net/http"
require "json"
class VdoCipher
	def initialize(conf)
		@key = conf[:clientSecretKey]
	end
	def play_code(id)
		url = URI.parse('http://api.vdocipher.com/v2/otp?video='+ id)
		req = Net::HTTP::Post.new(url.to_s)
		req.body = 'clientSecretKey=' + @key
		res = Net::HTTP.start(url.host, url.port) {|http|
					http.request(req)
		}
		otp = JSON.parse(res.body)
		embedcode = <<EOS
<div id="vdo%s" style="height:400px;width:640px;max-width:100%%;"></div>
<script>
	(function(v,i,d,e,o){v[o]=v[o]||{}; v[o].add = v[o].add || function V(a){ (v[o].d=v[o].d||[]).push(a);};
	 if(!v[o].l) { v[o].l=1*new Date(); a=i.createElement(d), m=i.getElementsByTagName(d)[0];
	 a.async=1; a.src=e; m.parentNode.insertBefore(a,m);}
	})(window,document,"script","//de122v0opjemw.cloudfront.net/vdo.js","vdo");
	vdo.add({o: "%s"});
</script>
EOS
		embedcode = embedcode % [otp["otp"] , otp["otp"]]
	end
end
