// Learn cc.Class:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/class.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/class.html
// Learn Attribute:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/reference/attributes.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/reference/attributes.html
// Learn life-cycle callbacks:
//  - [Chinese] http://docs.cocos.com/creator/manual/zh/scripting/life-cycle-callbacks.html
//  - [English] http://www.cocos2d-x.org/docs/creator/en/scripting/life-cycle-callbacks.html

var hero =  require('helloworld');
var common = require("common");

// var Sprite = cc.Class({
//     name = 'sprite',
// });
var Persion = require('Persion');

cc.Class({
    extends: cc.Component,

    properties: {
        // foo: {
        //     // ATTRIBUTES:
        //     default: null,        // The default value will be used only when the component attaching
        //                           // to a node for the first time
        //     type: cc.SpriteFrame, // optional, default is typeof default
        //     serializable: true,   // optional, default is true
        // },
        // bar: {
        //     get () {
        //         return this._bar;
        //     },
        //     set (value) {
        //         this._bar = value;
        //     }
        // },
        alert: {
            default: null,
            type: cc.Sprite
        },
        messageLabel: {
            default: null,
            type: cc.Label
        },
    },

    // LIFE-CYCLE CALLBACKS:

    // onLoad () {},


    onEnable: function () {
        cc.director.getCollisionManager().enabled = true;
    },
    
    onDisable: function () {
        cc.director.getCollisionManager().enabled = false;
    },
    
    onCollisionEnter: function (other, self) {
      
        cc.log(hero);

        this.alert.node.active = true;

        hero.stop();
        var backLabel =  Global.backLabel;
        cc.log(common.backLabel);
        console.log(self.tag);
        if(self.tag == 1){
            //alert('挂了')
            this.messageLabel.string =  "挂了";
            return;
        }

        this.messageLabel.string =  "赢了";

        backLabel.string = "234444444";
        //alert(123)
    },

    onLoad (){
        var obj = new Persion();
        cc.log(obj)
        cc.log(obj instanceof Persion)
        cc.log('onLoad--monster');

    },

    start () {
    },

    update (dt) {
        //cc.log(dt)
    },
});
