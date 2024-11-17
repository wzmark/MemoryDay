import router from '@ohos.router';


@Component

export struct ReturnButton{
        @Prop url: string;
        build() {
                Row(){
                        Button(){
                                Image($r('app.media.return'))
                                        .width('10%')
                                        .height('5%')
                                        .fillColor(Color.White)

                        }.onClick(() => {
                                router.pushUrl({
                                        url: this.url
                                }, router.RouterMode.Standard)
                        }).backgroundColor('#00000000')
                        Text("返回")
                                .fontSize(24)
                                .fontWeight(FontWeight.Bold)
                                .fontColor("#ffffff")
                                .onClick(() => {
                                        router.pushUrl({
                                                url: this.url
                                        }, router.RouterMode.Standard)
                                })
                }

        }
}