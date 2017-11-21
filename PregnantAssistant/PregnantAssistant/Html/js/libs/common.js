void function(){
    if(/ipad|iphone|mac/i.test(navigator.userAgent)){//ios-font
        var node = document.createElement('style');
        node.type = 'text/css';
        node.innerHTML = '* {font-family: "Heiti SC";}';
        document.getElementsByTagName('head')[0].appendChild(node);
    }
}();