{ fetchgit, runCommand }:
let
  srcs = {
    "https://github.com/armon/go-metrics" = fetchgit {
      url = https://github.com/armon/go-metrics;
      rev = "6c5fa0d8f48f4661c9ba8709799c88d425ad20f0";
      sha256 = "7321b4078de3fe65a76acf9bf116c18e053854f439afcde33b9d052c2cab9b0d";
    };
    
    "https://github.com/armon/go-radix" = fetchgit {
      url = https://github.com/armon/go-radix;
      rev = "fbd82e84e2b13651f3abc5ffd26b65ba71bc8f93";
      sha256 = "ddd7ec37ddc1ad2977e9491366738b922536b0dabd0981fd4b19e54946a8b052";
    };
    
    "https://github.com/asaskevich/govalidator" = fetchgit {
      url = https://github.com/asaskevich/govalidator;
      rev = "edd46cdac249b001c7b7d88c6d43993ea875e8d8";
      sha256 = "f30a23056d0970c6c06ffd93efdb6ccc0d0928f5ee59c351da635de8ddc5c576";
    };
    
    "https://github.com/aws/aws-sdk-go" = fetchgit {
      url = https://github.com/aws/aws-sdk-go;
      rev = "cb8f6e2243db557350e4ff8f786590881e4149b6";
      sha256 = "7cdc42abc056eb0db0c69fe3011a81e09012fe6a1243cb92c517c80bb9523839";
    };
    
    "https://github.com/coreos/etcd" = fetchgit {
      url = https://github.com/coreos/etcd;
      rev = "858857d7013af3142310aa2cef9a29d6a2edb736";
      sha256 = "5eabb1c6e867d478ac29605a126242c275d7ca62996570feb488aab807484073";
    };
    
    "https://github.com/duosecurity/duo_api_golang" = fetchgit {
      url = https://github.com/duosecurity/duo_api_golang;
      rev = "16da9e74793f6d9b97b227a0696fe32bcdaecb42";
      sha256 = "b5759d66afa4caaaebf37772edafffc5c24703ef824dac8fbf633e772504f2bc";
    };
    
    "https://github.com/fatih/structs" = fetchgit {
      url = https://github.com/fatih/structs;
      rev = "9a7733345ff091c5457cb963f498a79ecd0bdbaa";
      sha256 = "6ca92d144c2d8c1c6a7aeb6817f453b1686e862ce541fe6c484466a7a607d29c";
    };
    
    "https://github.com/ghodss/yaml" = fetchgit {
      url = https://github.com/ghodss/yaml;
      rev = "73d445a93680fa1a78ae23a5839bad48f32ba1ee";
      sha256 = "6427f87096445434d0169d1f861fbee2e0250b86bc49d58533f70bf98e511a01";
    };
    
    "https://github.com/go-asn1-ber/asn1-ber" = fetchgit {
      url = https://github.com/go-asn1-ber/asn1-ber;
      rev = "4e86f4367175e39f69d9358a5f17b4dda270378d";
      sha256 = "933b104031a563b792263bb2b0b982d1ce8cceeabc5f47272d8bce3fc9d1e88e";
    };
    
    "https://github.com/go-inf/inf" = fetchgit {
      url = https://github.com/go-inf/inf;
      rev = "3887ee99ecf07df5b447e9b00d9c0b2adaa9f3e4";
      sha256 = "022df4f1c326cb38f715557a135421cc8852fee9cab4d41353162bb43cdfc365";
    };
    
    "https://github.com/go-ini/ini" = fetchgit {
      url = https://github.com/go-ini/ini;
      rev = "03e0e7d51a13a91c765d8d0161246bc14a38001a";
      sha256 = "835b57adb0218d70210026576a626564e48ee282cbf03dc267978a557afc69d4";
    };
    
    "https://github.com/go-ldap/ldap" = fetchgit {
      url = https://github.com/go-ldap/ldap;
      rev = "e9a325d64989e2844be629682cb085d2c58eef8d";
      sha256 = "5b2f8ba749dfdb4cec95e3368548485cccd4caca86ded31fd1dfe871f3579b1d";
    };
    
    "https://github.com/go-sql-driver/mysql" = fetchgit {
      url = https://github.com/go-sql-driver/mysql;
      rev = "d512f204a577a4ab037a1816604c48c9c13210be";
      sha256 = "f7f05e2fd8dede3ba8346ee4369615eb03a0829f934f15bd1bf3771f34acfa55";
    };
    
    "https://github.com/go-yaml/yaml" = fetchgit {
      url = https://github.com/go-yaml/yaml;
      rev = "53feefa2559fb8dfa8d81baad31be332c97d6c77";
      sha256 = "0f127322279fc9f25f0b982739bb5e7297a323e85e7eeb0640e116fc7ebbdaa9";
    };
    
    "https://github.com/gocql/gocql" = fetchgit {
      url = https://github.com/gocql/gocql;
      rev = "87cc1854b57c7a4d8f4ae1d0cc358ed6ecb0f8c3";
      sha256 = "779b24022e2d6db269f67069ef2856036ff9c9e33a7deceede5a3a423fc8fddf";
    };
    
    "https://github.com/golang/crypto" = fetchgit {
      url = https://github.com/golang/crypto;
      rev = "7b85b097bf7527677d54d3220065e966a0e3b613";
      sha256 = "8a22df0971f65ae4b43fa3c40e04b168c0f7a73776029d1e58eeeb7ada1e5240";
    };
    
    "https://github.com/golang/net" = fetchgit {
      url = https://github.com/golang/net;
      rev = "195180cfebf7362bd243a52477697895128c8777";
      sha256 = "f79d49749ac2db9aa72b1a43c66ff37b9882cea644a4f78a919e083a8d3e29d8";
    };
    
    "https://github.com/golang/oauth2" = fetchgit {
      url = https://github.com/golang/oauth2;
      rev = "442624c9ec9243441e83b374a9e22ac549b5c51d";
      sha256 = "6e76ecba00e11965781d307b0b897fb7878c22cba35fcb7d40abd0ecf933a21c";
    };
    
    "https://github.com/golang/snappy" = fetchgit {
      url = https://github.com/golang/snappy;
      rev = "723cc1e459b8eea2dea4583200fd60757d40097a";
      sha256 = "d08cd2330b16ec6c8218d09385be88184ffd316e99e9b24228c519b230c0f92e";
    };
    
    "https://github.com/google/go-github" = fetchgit {
      url = https://github.com/google/go-github;
      rev = "47f2593dad1971eec2f0a0971aa007fef5edbc50";
      sha256 = "ee3cc66c1e379bc70753e92bb2e57605d927fc433335e11f4b3cfbc45a3aaa6b";
    };
    
    "https://github.com/google/go-querystring" = fetchgit {
      url = https://github.com/google/go-querystring;
      rev = "2a60fc2ba6c19de80291203597d752e9ba58e4c0";
      sha256 = "6ae6e0dc2e58d37bf9d602b3bd73be5aab9c73b4972e46eeb8605f034c08e284";
    };
    
    "https://github.com/hailocab/go-hostpool" = fetchgit {
      url = https://github.com/hailocab/go-hostpool;
      rev = "0637eae892be221164aff5fcbccc57171aea6406";
      sha256 = "243958e8758df84d5b24225b092e41377949da96e29144aa7a7b4277e339dd7a";
    };
    
    "https://github.com/hashicorp/consul" = fetchgit {
      url = https://github.com/hashicorp/consul;
      rev = "86f20a32e5afe1fbcd98129239cdea4bf8b0d5ba";
      sha256 = "8596cc2507c348398ff5341a2446b54e8a9f00fee6e7e7714610372092d129c7";
    };
    
    "https://github.com/hashicorp/errwrap" = fetchgit {
      url = https://github.com/hashicorp/errwrap;
      rev = "7554cd9344cec97297fa6649b055a8c98c2a1e55";
      sha256 = "4e0aa428b98c47ed72ef3be99976051505add5c7e89c10119326b602cc05bb4e";
    };
    
    "https://github.com/hashicorp/go-cleanhttp" = fetchgit {
      url = https://github.com/hashicorp/go-cleanhttp;
      rev = "5df5ddc69534f1a4697289f1dca2193fbb40213f";
      sha256 = "f05c836afcac2c30af83273a12f4e9fc64ec6d6820058894bc410a4990c3a854";
    };
    
    "https://github.com/hashicorp/go-multierror" = fetchgit {
      url = https://github.com/hashicorp/go-multierror;
      rev = "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5";
      sha256 = "3f8e0f809c43744023db06ce47a271dd521db5441c5a11a0551b86b077158035";
    };
    
    "https://github.com/hashicorp/go-syslog" = fetchgit {
      url = https://github.com/hashicorp/go-syslog;
      rev = "42a2b573b664dbf281bd48c3cc12c086b17a39ba";
      sha256 = "1396083486b951ed3aff15aa000c7e42cac8d97790e164975cefd0c59521c6d6";
    };
    
    "https://github.com/hashicorp/golang-lru" = fetchgit {
      url = https://github.com/hashicorp/golang-lru;
      rev = "b361c4c189a958f7d0ad435952611c140751afe2";
      sha256 = "386e31e031c7a0f150512e972d077319c6f4cbdf3e15623437f405f484200950";
    };
    
    "https://github.com/hashicorp/hcl" = fetchgit {
      url = https://github.com/hashicorp/hcl;
      rev = "4de51957ef8d4aba6e285ddfc587633bbfc7c0e8";
      sha256 = "b9017011e43dd41cb0a40cdc04df4d3873a1664f17c7eaa8f426e41afc6434ce";
    };
    
    "https://github.com/hashicorp/logutils" = fetchgit {
      url = https://github.com/hashicorp/logutils;
      rev = "0dc08b1671f34c4250ce212759ebd880f743d883";
      sha256 = "20cfda66781272ae24e6fe9b2cd13eee1016459dc31d52459f21debc6be46ed3";
    };
    
    "https://github.com/hashicorp/serf" = fetchgit {
      url = https://github.com/hashicorp/serf;
      rev = "a72c0453da2ba628a013e98bf323a76be4aa1443";
      sha256 = "726a839587bcc05108d2e2341df110496a1e73dfc6579cc0e976a7620e3ea1c4";
    };
    
    "https://github.com/hashicorp/uuid" = fetchgit {
      url = https://github.com/hashicorp/uuid;
      rev = "2951e8b9707a040acdb49145ed9f36a088f3532e";
      sha256 = "b7a3cc9083af712591ea1fb384a481be5309999437543976fa32608433938b14";
    };
    
    "https://github.com/jmespath/go-jmespath" = fetchgit {
      url = https://github.com/jmespath/go-jmespath;
      rev = "3433f3ea46d9f8019119e7dd41274e112a2359a9";
      sha256 = "e00bd7ceb8097a87a71ed89542cee30accfae124210d4314eba223da65f5aa06";
    };
    
    "https://github.com/kardianos/osext" = fetchgit {
      url = https://github.com/kardianos/osext;
      rev = "10da29423eb9a6269092eebdc2be32209612d9d2";
      sha256 = "0a6d0fc566b6098c2b1b5b59a9d7ec8bc12e4b73c9993fa5352112f415555cd5";
    };
    
    "https://github.com/lib/pq" = fetchgit {
      url = https://github.com/lib/pq;
      rev = "11fc39a580a008f1f39bb3d11d984fb34ed778d9";
      sha256 = "e90a561be2a0a1be5c5e0a819b3f8221fa8b5d6e56c0734d6cd70f985e75f38f";
    };
    
    "https://github.com/mitchellh/cli" = fetchgit {
      url = https://github.com/mitchellh/cli;
      rev = "8102d0ed5ea2709ade1243798785888175f6e415";
      sha256 = "a21e7e52f2cc8f3c0277534fa672062c5e381051693e32bc1487f34b120db222";
    };
    
    "https://github.com/mitchellh/copystructure" = fetchgit {
      url = https://github.com/mitchellh/copystructure;
      rev = "6fc66267e9da7d155a9d3bd489e00dad02666dc6";
      sha256 = "2df7553306a91c0a4d18b39576fcfe2a33226461db17e7e5b5a821c3e12e7aa4";
    };
    
    "https://github.com/mitchellh/go-homedir" = fetchgit {
      url = https://github.com/mitchellh/go-homedir;
      rev = "d682a8f0cf139663a984ff12528da460ca963de9";
      sha256 = "7acd208fcbaa2d1a9490cc98eeda23f8be7f8b36acf263003e5fcde5925f516f";
    };
    
    "https://github.com/mitchellh/mapstructure" = fetchgit {
      url = https://github.com/mitchellh/mapstructure;
      rev = "281073eb9eb092240d33ef253c404f1cca550309";
      sha256 = "b0865e345a4d150a832fcda3a1d7b9ef7c3090ee9920ebc2d5699824b64b5dfe";
    };
    
    "https://github.com/mitchellh/reflectwalk" = fetchgit {
      url = https://github.com/mitchellh/reflectwalk;
      rev = "eecf4c70c626c7cfbb95c90195bc34d386c74ac6";
      sha256 = "b8df877e3bad5a539a7dcb59ebc000e213734f430daf763801ae52fece8ba2da";
    };
    
    "https://github.com/ryanuber/columnize" = fetchgit {
      url = https://github.com/ryanuber/columnize;
      rev = "983d3a5fab1bf04d1b412465d2d9f8430e2e917e";
      sha256 = "e62a27d307bfaee89d4307dc431b5e23de9d5cebe644d598fb84ccb09e823255";
    };
    
    "https://github.com/samuel/go-zookeeper" = fetchgit {
      url = https://github.com/samuel/go-zookeeper;
      rev = "218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f";
      sha256 = "5bdd6900574e0c79e39841c67930b9440da0285d5fd85e46df9c2b00fdafe77c";
    };
    
    "https://github.com/ugorji/go" = fetchgit {
      url = https://github.com/ugorji/go;
      rev = "1a8bf87a90ddcdc7deaa0038f127ac62135fdd58";
      sha256 = "e046433f37c43ab2eedb4352edfec3e11d8c132c5a4f354091446b00d5cafdc8";
    };

  };
in
runCommand "Godeps" {} ''
  mkdir -p $out/github.com/armon
  ln -sn ${srcs."https://github.com/armon/go-metrics"} $out/github.com/armon/go-metrics
  
  mkdir -p $out/github.com/armon
  ln -sn ${srcs."https://github.com/armon/go-radix"} $out/github.com/armon/go-radix
  
  mkdir -p $out/github.com/asaskevich
  ln -sn ${srcs."https://github.com/asaskevich/govalidator"} $out/github.com/asaskevich/govalidator
  
  mkdir -p $out/github.com/aws
  ln -sn ${srcs."https://github.com/aws/aws-sdk-go"} $out/github.com/aws/aws-sdk-go
  
  mkdir -p $out/github.com/coreos
  ln -sn ${srcs."https://github.com/coreos/etcd"} $out/github.com/coreos/etcd
  
  mkdir -p $out/github.com/duosecurity
  ln -sn ${srcs."https://github.com/duosecurity/duo_api_golang"} $out/github.com/duosecurity/duo_api_golang
  
  mkdir -p $out/github.com/fatih
  ln -sn ${srcs."https://github.com/fatih/structs"} $out/github.com/fatih/structs
  
  mkdir -p $out/github.com/ghodss
  ln -sn ${srcs."https://github.com/ghodss/yaml"} $out/github.com/ghodss/yaml
  
  mkdir -p $out/gopkg.in
  ln -sn ${srcs."https://github.com/go-asn1-ber/asn1-ber"} $out/gopkg.in/asn1-ber.v1
  
  mkdir -p $out/gopkg.in
  ln -sn ${srcs."https://github.com/go-inf/inf"} $out/gopkg.in/inf.v0
  
  mkdir -p $out/github.com/go-ini
  ln -sn ${srcs."https://github.com/go-ini/ini"} $out/github.com/go-ini/ini
  
  mkdir -p $out/github.com/go-ldap
  ln -sn ${srcs."https://github.com/go-ldap/ldap"} $out/github.com/go-ldap/ldap
  
  mkdir -p $out/github.com/go-sql-driver
  ln -sn ${srcs."https://github.com/go-sql-driver/mysql"} $out/github.com/go-sql-driver/mysql
  
  mkdir -p $out/gopkg.in
  ln -sn ${srcs."https://github.com/go-yaml/yaml"} $out/gopkg.in/yaml.v2
  
  mkdir -p $out/github.com/gocql
  ln -sn ${srcs."https://github.com/gocql/gocql"} $out/github.com/gocql/gocql
  
  mkdir -p $out/golang.org/x
  ln -sn ${srcs."https://github.com/golang/crypto"} $out/golang.org/x/crypto
  
  mkdir -p $out/golang.org/x
  ln -sn ${srcs."https://github.com/golang/net"} $out/golang.org/x/net
  
  mkdir -p $out/golang.org/x
  ln -sn ${srcs."https://github.com/golang/oauth2"} $out/golang.org/x/oauth2
  
  mkdir -p $out/github.com/golang
  ln -sn ${srcs."https://github.com/golang/snappy"} $out/github.com/golang/snappy
  
  mkdir -p $out/github.com/google
  ln -sn ${srcs."https://github.com/google/go-github"} $out/github.com/google/go-github
  
  mkdir -p $out/github.com/google
  ln -sn ${srcs."https://github.com/google/go-querystring"} $out/github.com/google/go-querystring
  
  mkdir -p $out/github.com/hailocab
  ln -sn ${srcs."https://github.com/hailocab/go-hostpool"} $out/github.com/hailocab/go-hostpool
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/consul"} $out/github.com/hashicorp/consul
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/errwrap"} $out/github.com/hashicorp/errwrap
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/go-cleanhttp"} $out/github.com/hashicorp/go-cleanhttp
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/go-multierror"} $out/github.com/hashicorp/go-multierror
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/go-syslog"} $out/github.com/hashicorp/go-syslog
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/golang-lru"} $out/github.com/hashicorp/golang-lru
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/hcl"} $out/github.com/hashicorp/hcl
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/logutils"} $out/github.com/hashicorp/logutils
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/serf"} $out/github.com/hashicorp/serf
  
  mkdir -p $out/github.com/hashicorp
  ln -sn ${srcs."https://github.com/hashicorp/uuid"} $out/github.com/hashicorp/uuid
  
  mkdir -p $out/github.com/jmespath
  ln -sn ${srcs."https://github.com/jmespath/go-jmespath"} $out/github.com/jmespath/go-jmespath
  
  mkdir -p $out/github.com/kardianos
  ln -sn ${srcs."https://github.com/kardianos/osext"} $out/github.com/kardianos/osext
  
  mkdir -p $out/github.com/lib
  ln -sn ${srcs."https://github.com/lib/pq"} $out/github.com/lib/pq
  
  mkdir -p $out/github.com/mitchellh
  ln -sn ${srcs."https://github.com/mitchellh/cli"} $out/github.com/mitchellh/cli
  
  mkdir -p $out/github.com/mitchellh
  ln -sn ${srcs."https://github.com/mitchellh/copystructure"} $out/github.com/mitchellh/copystructure
  
  mkdir -p $out/github.com/mitchellh
  ln -sn ${srcs."https://github.com/mitchellh/go-homedir"} $out/github.com/mitchellh/go-homedir
  
  mkdir -p $out/github.com/mitchellh
  ln -sn ${srcs."https://github.com/mitchellh/mapstructure"} $out/github.com/mitchellh/mapstructure
  
  mkdir -p $out/github.com/mitchellh
  ln -sn ${srcs."https://github.com/mitchellh/reflectwalk"} $out/github.com/mitchellh/reflectwalk
  
  mkdir -p $out/github.com/ryanuber
  ln -sn ${srcs."https://github.com/ryanuber/columnize"} $out/github.com/ryanuber/columnize
  
  mkdir -p $out/github.com/samuel
  ln -sn ${srcs."https://github.com/samuel/go-zookeeper"} $out/github.com/samuel/go-zookeeper
  
  mkdir -p $out/github.com/ugorji
  ln -sn ${srcs."https://github.com/ugorji/go"} $out/github.com/ugorji/go

''
