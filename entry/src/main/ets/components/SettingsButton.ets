import router from '@ohos.router';


@Component

export struct SettingsButton{

        build() {

                Button(){
                        Image($r('app.media.settings'))
                                .width('10%')
                                .height('5%')
                                .fillColor(Color.White)

                }.onClick(() => {
                        router.pushUrl({
                                url: "pages/Settings"
                        }, router.RouterMode.Standard)
                        console.log("jump")
                }).backgroundColor('#00000000')
        }
}