export default {
    logo: (
        <span style={{
            fontWeight: 800,
            fontSize: '1.5rem',
            letterSpacing: '-0.05em',
            display: 'flex',
            alignItems: 'center'
        }}>
            <span style={{ color: '#FF3B30' }}>F</span>
            <span style={{ marginLeft: '-2px' }}>lux</span>
        </span>
    ),
    project: {
        link: 'https://github.com/zainulnazir/flux'
    },
    docsRepositoryBase: 'https://github.com/zainulnazir/flux/tree/main/docs/pages/docs',
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
    navbar: {
        extraContent: (
            <>
                <a href="/docs/features" style={{ padding: '0 10px', fontSize: '0.9rem', fontWeight: 500 }}>Features</a>
                <a
                    href="#"
                    onClick={(e) => {
                        e.preventDefault();
                        window.location.href = `mailto:${'haditbutt7' + '@' + 'gmail.com'}`;
                    }}
                    style={{ padding: '0 10px', fontSize: '0.9rem', fontWeight: 500 }}
                >
                    Contact
                </a>
            </>
        )
    },
    footer: {
        text: (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
                <span>MIT {new Date().getFullYear()} © <a href="https://github.com/zainulnazir" target="_blank">Zain Ul Nazir</a></span>
                <div style={{ display: 'flex', gap: '12px', fontSize: '0.85rem', color: 'rgba(255,255,255,0.5)' }}>
                    <a href="https://github.com/zainulnazir/flux" target="_blank" rel="noopener noreferrer" style={{ color: 'inherit' }}>GitHub</a>
                    <a href="https://instagram.com/zaynulnazir" target="_blank" rel="noopener noreferrer" style={{ color: 'inherit' }}>Instagram</a>
                </div>
            </div>
        )
    },
    primaryHue: 12,
    primarySaturation: 100,
    sidebar: {
        defaultMenuCollapseLevel: 1,
        toggleButton: true
    }
}
