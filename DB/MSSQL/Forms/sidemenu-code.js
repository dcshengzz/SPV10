{
//  validate: function ({data, originalData, state, component, formName, index, controlRef, eventArgs, isChild}){
//    var errors = {};
//    //TODO: Insert your code for validation this form
//    if(data.name == undefined || data.name == ''){
//      errors.name = 'This field is requered!';
//    }
//    if(errors.name){
//      throw {
//          level: 1,
//          message: 'Check errors on the form!',
//          formerrors: {main: errors}
//      };
//    }
//    return {};
//  }
    onItemClick: function(args) {
        console.log(args);
        let target = args.parameters.target;
        if(target && target != "") {
            if("NEW " === target.substring(0,4)) {
                target = target.substring(4);
                const title = target;
                window.open(target, title);
            } else {
                args.state.router.history.push( target );
            }
        }
    },
    init: function(args) {
       // console.log(args);
        return {
            component: {
                refs: {
                    sidemenu: {
                        props: {
                            "data-items": [],
                        }
                    }
                }
            }
        };
    }
}