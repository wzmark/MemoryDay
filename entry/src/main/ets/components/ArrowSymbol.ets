import router from '@ohos.router';


@Component

export struct ArrowSymbol{
        @Prop angle: number
        build() {


                Image($r('app.media.plus'))
                        .width('10%')
                        .height('5%')
                        .fillColor(Color.White).rotate({angle: this.angle})


        }
}