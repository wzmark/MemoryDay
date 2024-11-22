import router from '@ohos.router';
import { EventItem } from '../model/EventModel';

export interface Params{
        click: () => void
}
@Component

export struct DeleteButton{
        @Prop onButtonClick: Params
        build() {

                Button("删除").onClick(() => {


                        AlertDialog.show({
                                title: "删除事件记录", //弹窗标题
                                message: '确认删除吗？', // 提示消息
                                autoCancel:false,// 点击遮罩层即阴影，是否关闭弹窗。true是点击遮罩层弹窗关闭。
                                alignment: DialogAlignment.Bottom, //弹窗位置
                                offset: { dx: 0, dy: -30 }, // 相对弹窗位置即DialogAlignment.Bottom 在x轴和y轴偏移
                                primaryButton: {
                                        value: "确定",
                                        fontColor:Color.Red,
                                        action: () => {
                                                this.onButtonClick.click()
                                                setTimeout(async () => {
                                                        router.pushUrl({
                                                                url: "pages/Index"
                                                        }, router.RouterMode.Standard)
                                                }, 1000);
                                        }
                                },
                                secondaryButton: {
                                        value: "取消",
                                        action: () => {
                                        }
                                },
                                cancel:() => {// 点击遮罩层后，遮罩层消失弹窗自动关闭时候触发，此时必须autoCancel:true，为false则失效
                                        console.log('点击遮罩层后，遮罩层消失弹窗自动关闭时候触发');
                                }

                        })




                        console.log("jump")
                }).backgroundColor('#ffff0000').fontColor("#ffffff").fontSize(24).width("100%")
        }
}