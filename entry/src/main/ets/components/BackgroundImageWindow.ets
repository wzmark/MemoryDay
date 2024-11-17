import router from '@ohos.router';


@Component

export struct BackgroundImageWindow{
        @Prop photoUrl: string;
        build() {
                Image($r(this.photoUrl))
                        .width('60%')
                        .fillColor(Color.White).clip(true).borderRadius(10)
                        .border({
                                width: "8px",
                                color: Color.White
                        })

        }
}