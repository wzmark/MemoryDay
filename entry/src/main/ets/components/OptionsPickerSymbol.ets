import router from '@ohos.router';


@Component

export struct OptionsPickerSymbol{
        @Prop angle: number = 180
        build() {


                Image($r('app.media.return'))
                        .width('6%')
                        .height('30%')
                        .fillColor(Color.White).rotate({angle: this.angle})


        }
}