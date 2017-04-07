

function talentcGetAllImageSrc ()
{
  var imagesList = document.images;
  var srcList = [];
  var patt1 = new RegExp("\.webp$");
  for(var i = 0; i < imagesList.length; i++) {
    if(patt1.test(imagesList[i].src)) {
        srcList.push(imagesList[i].src);
      }
  }
  return JSON.stringify(srcList);
};



function talentcReplaceWebPImg (src, localPath)
{
    var elementList = document.querySelectorAll('img[src="'+src+'"]');
    for(var element in elementList) {
        elementList[element].src = localPath;
    }
}
