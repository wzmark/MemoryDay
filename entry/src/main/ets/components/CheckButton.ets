import router from '@ohos.router';

export interface Params{
        click: () => void
}
@Component

export struct CheckButton{
        @Prop onButtonClick: Params


        build() {

                Button(){
                        Image($r('app.media.check'))
                                .width('10%')
                                .height('5%')
                                .fillColor(Color.White)

                }.onClick(() => {

                        this.onButtonClick.click()
                        console.log("jump")
                        setTimeout(async () => {
                                router.pushUrl({
                                        url: "pages/Index"
                                }, router.RouterMode.Standard)
                        }, 1000);
                }).backgroundColor('#00000000')
        }
}