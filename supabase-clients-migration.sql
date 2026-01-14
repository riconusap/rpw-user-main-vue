-- Create clients table
CREATE TABLE IF NOT EXISTS public.clients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL,
    order_position INTEGER NOT NULL DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create index on order_position for better sorting performance
CREATE INDEX IF NOT EXISTS idx_clients_order_position ON public.clients(order_position);

-- Create index on is_active for filtering
CREATE INDEX IF NOT EXISTS idx_clients_is_active ON public.clients(is_active);

-- Enable Row Level Security
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access (only active clients)
CREATE POLICY "Allow public read access to active clients"
    ON public.clients
    FOR SELECT
    USING (is_active = true);

-- Create policy for authenticated users to read all clients (for admin)
CREATE POLICY "Allow authenticated users to read all clients"
    ON public.clients
    FOR SELECT
    TO authenticated
    USING (true);

-- Create policy for authenticated users to insert clients
CREATE POLICY "Allow authenticated users to insert clients"
    ON public.clients
    FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Create policy for authenticated users to update clients
CREATE POLICY "Allow authenticated users to update clients"
    ON public.clients
    FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Create policy for authenticated users to delete clients
CREATE POLICY "Allow authenticated users to delete clients"
    ON public.clients
    FOR DELETE
    TO authenticated
    USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_clients_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_clients_updated_at
    BEFORE UPDATE ON public.clients
    FOR EACH ROW
    EXECUTE FUNCTION public.update_clients_updated_at();

-- Insert sample data (optional)
INSERT INTO public.clients (name, logo_url, order_position, is_active) VALUES
('Sample Client 1', 'https://via.placeholder.com/200x200.png?text=Client+1', 1, true),
('Sample Client 2', 'https://via.placeholder.com/200x200.png?text=Client+2', 2, true),
('Sample Client 3', 'https://via.placeholder.com/200x200.png?text=Client+3', 3, true)
ON CONFLICT DO NOTHING;

-- Grant permissions
GRANT SELECT ON public.clients TO anon;
GRANT ALL ON public.clients TO authenticated;
