export default {
    logo: <span style={{ fontWeight: 800, fontSize: '1.5rem', letterSpacing: '-0.02em' }}>
        <span style={{ color: '#FF3B30' }}>F</span>lux
    </span>,
    project: {
        link: 'https://github.com/zainulnazir/flux'
    },
    docsRepositoryBase: 'https://github.com/zainulnazir/flux/tree/main/flux/docs',
    useNextSeoProps() {
        return {
            titleTemplate: '%s – Flux'
        }
    },
    head: (
        <>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta name="description" content="Flux: The Ultimate macOS Media Center" />
            <meta name="og:title" content="Flux: Native macOS Media Center" />
        </>
    ),
    footer: {
        text: (
            <span>
                MIT {new Date().getFullYear()} © <a href="https://github.com/zainulnazir" target="_blank">Zainul Nazir</a>.
            </span>
        )
    },
    primaryHue: 12,
    primarySaturation: 100,
    sidebar: {
        defaultMenuCollapseLevel: 1
    }
}
