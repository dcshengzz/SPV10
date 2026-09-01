{
    init: function(args) {
        console.log("args to init",args);
        shortlinkUserActions.updateFormChoices(args);
        shortlinkUserActions.getShortLinkQrCode(args);
    },
    
    updateFormChoices: function(args) {
        const dplyId = args.data.DplyId;
        const formName = args.data.FormName;
        
        if(dplyId) {
            Utils.loadingStart();
            Utils.getRequest("/deployment/getForms", { dplyId }).then(
                response => {
                    const forms = response.item;
                    const items = [];
                    for(const form of forms) {
                        items.push( {
                           key: form.Id,
                           text: form.Name + " / " + form.Language,
                           value: form.Name,
                        });
                    }
                    Utils.rewriteDropdown("FormName",items, formName);
                }, reason => {
                    console.error(reason);
                    alertify.error( Utils.encodeHTML(reason) );
                }
            ).finally(Utils.loadingStop);
        } else {
            Utils.rewriteDropdown("FormName",[]);
        }
        
        
    },
    
    cleanup: function(args) {
        const data = args.data;
        
        if(data.LinkType=="Anonymous") {
            CloverApp.API.setDataField("Url",null);
        } else {
            CloverApp.API.setDataField("DplyId",null);
        }
      
        
    },
    
    getShortLinkQrCode: function (args){
        const id =  args.data.Id;
        if(id==null) {
            console.log("Not saved yet", id);
            CloverApp.API.setDataField("shortLinkQrCode", "");
            return {};
        }
        
        const iconClass = "copy outline icon";
        const iconBtnClass = "ui icon button mini secondary";
        let htmlLink = "";
        Utils.loadingStart();
        Utils.getRequest("/shortlink/info",{id}).then(
            response => {
                console.log("response",response);
                const item = response.item;
                    
                //html here is based on the anonymous qr html used in qnn_dply
                htmlLink += '<div><i style="display:block;margin-bottom:14px;">Click the copy button to get Short Link URL:</i>';
    
                const iconBtn = 
                     '<button id="btnCopy-shortlink" name="btnCopy-shortlink" title="Copy" data-link-id="shortLink" class="'
                     +iconBtnClass+'"><i data-link-id="shortLink" class="'+iconClass+'" ariahidden="true"></i></button>';
                const urlText = '<span id="shortlinkText" style="display:none;">'+item.url +'</span>';
                const headerDiv = '<div style="margin:18px 18px 0px 18px; word-break: break-word;">'+iconBtn +' ' +urlText+'</div>';
                const qrCodeImg = '<img style="display:block; margin-left:auto; margin-right:auto; margin-bottom:9px; width:200px; height:200px" src="data:image/png;base64,' + item.qrCode +'"  alt="'+item.url+'"/>';
                const linkItem = '<div style="width:210px;margin-bottom:14px;margin-right:14px;float:left;border:1px solid rgba(34, 36, 38, 0.15);">'+ headerDiv + qrCodeImg + '</div>';
                htmlLink += linkItem;
                
                htmlLink += "</div>"
                
                CloverApp.API.setDataField("shortLinkQrCode", htmlLink);
                
                //Due to security issue does not allow "unsafe inline", bind separately (but will only be one here)
                document.getElementsByName("btnCopy-shortlink").forEach(function(btn){
                   btn.addEventListener("click",function(e){
                       e.preventDefault();
                       navigator.clipboard.writeText(item.url);
                       alertify.success( Utils.encodeHTML("Copied to clipboard: " + item.url) );
                   })
                });
            }, reason => {
                console.error(reason);
                alertify.error( Utils.encodeHTML("Failed to load QR Code: " +  reason) );
            }
        ).finally(Utils.loadingStop);
    },
    
}