(function($){
	
	$.namespace("encrypt");
	
	// 암호화 솔루션 JS 로딩
	if(!$.isFwkMode){
		$.loadScript("/XecureObject/xecureweb.js", function(){
			PrintObjectTag();
		});
	}

	// 암호화 인터페이스 구현
	$._addFunction(false, {
		enc: function(header, user){			
			var msg = $.config.ajaxOptions.query + "&header=" + header + "&user=" + user;			
			return {
				// TODO: Framework 존재하는 경우에 대한 처리 추가 
				q : BlockEnc('',msg)
			};
		},
		dec: function(msg){
			// TODO: Framework 존재하는 경우에 대한 처리 추가
			return $.convertObject(BlockDec(msg));			
		}
	});
})(naw);