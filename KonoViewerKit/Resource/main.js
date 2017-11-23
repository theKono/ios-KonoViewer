function highlightSentence(sentenceID) {
    var objID = "#sentence-" + sentenceID;
    var highlightObj = $(objID);
    removeHighLight();
    highlightObj.addClass('highlightBlock');
}

function removeHighLight() {
    
    $('.highlightBlock').removeClass('highlightBlock');
    
}

function scrollSentenceToTop(sentenceID) {
    
    var objID = "#sentence-" + sentenceID;
    var targetObj = $(objID);
    
    $(window).scrollTop(targetObj.offset().top);
}

function scrollSentenceToMiddle(sentenceID) {
    
    var objID = "#sentence-" + sentenceID;
    var targetObj = $(objID);
    var elementOffset = targetObj.offset().top;
    var targetLocation = $(window).height()/2;
    var moveOffset;
    
    if (elementOffset > targetLocation) {
        moveOffset = elementOffset - targetLocation;
    }
    else {
        moveOffset = elementOffset;
    }
    //$(window).scrollTop(moveOffset);
    var speed = 800;
    $('html, body').animate({scrollTop:moveOffset}, speed);
}

function highlightSelectedTextSection() {
    
    var selectedTextObj = $(window.getSelection().focusNode).parent();
    removeHighLight();
    selectedTextObj.addClass('highlightBlock');
    return selectedTextObj.attr('id');
}

