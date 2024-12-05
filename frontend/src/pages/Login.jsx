import { 
    Container, 
    Box, 
    Typography, 
    TextField, 
    Button, 
    Paper,
    InputAdornment,
    Link,
    useMediaQuery,
    useTheme
  } from '@mui/material';
  import { 
      AlternateEmail as EmailIcon,
      Lock as LockIcon 
  } from '@mui/icons-material';
  import { Formik, Form, Field } from 'formik';
  import * as Yup from 'yup';

  import FullLogo from '../components/FullLogo';
import { useContext } from 'react';
import UserContext from '../context/UserContext';
  

  
  // Validation schema
  const LoginSchema = Yup.object().shape({
    email: Yup.string()
      .email('Invalid email address')
      .required('Email is required'),
    password: Yup.string()
      .required('Password is required')
  });
  
  const Login = () => {
    const { isAuthenticated, token, setToken, setIsAuthenticated, setTokenExpired } = useContext(UserContext);

    const theme = useTheme();
    const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
    const handleSubmit = (values, { setSubmitting }) => {
      // fetch http://localhost:5000/api/auth/login

      fetch('http://localhost:5000/api/auth/login', {
        method: 'POST',
        headers: {
          'Authorization': token,
        },
        body: JSON.stringify(values)
      }).then(res => {
        if(res.status === 200) {
          return res.json();
        }
        else {
          alert('Invalid email or password');
          setSubmitting(false);
        }
      }).then(data => {
        if(data.token) {
          setToken(data.token);
          setIsAuthenticated(true);
          setTokenExpired(false);
        }
        else {
          alert('Invalid email or password');
          setSubmitting(false);
        }
      });

      // Simulate login process
      setTimeout(() => {
        alert(JSON.stringify(values, null, 2));
        setSubmitting(false);
      }, 400);
    };
    const handleRegisterBtn = (e) => {
      e.preventDefault();
      alert('Register a new business');
    };
  
    return (
      <Box
        sx={{
          position: 'relative',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          minHeight: '100vh',
          py: 4,
          backgroundColor: 'background.default'
        }}
      >
        
        <Container 
          component="main" 
          maxWidth="xs"
          sx={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            width: '100%',
            mt: 5,
            transform: 'translateY(-50px)'
          }}
        >
            <FullLogo />
          <Paper 
            elevation={isMobile ? 0 : 6}
            sx={{ 
              padding: 4, 
              display: 'flex', 
              flexDirection: 'column', 
              alignItems: 'center',
              width: '100%',
              maxWidth: 400,
              border: isMobile ? '1px solid rgba(0,0,0,0.12)' : 'none'
            }}
          >
            <Typography 
              component="h1" 
              variant="h5" 
              sx={{ mb: 3, textAlign: 'center' }}
            >
              Welcome Back!
            </Typography>
            
            <Formik
              initialValues={{ email: '', password: '' }}
              validationSchema={LoginSchema}
              onSubmit={handleSubmit}
            >
              {({ errors, touched, isSubmitting }) => (
                 <Form style={{ width: '100%' }}>
                  <Field
                    as={TextField}
                    variant="outlined"
                    margin="normal"
                    fullWidth
                    id="email"
                    label="Email Address"
                    placeholder="Email Address"
                    name="email"
                    autoComplete="email"
                    autoFocus
                    error={touched.email && Boolean(errors.email)}
                    helperText={touched.email && errors.email}
                    InputProps={{
                      startAdornment: (
                        <InputAdornment position="start">
                          <EmailIcon color="action" />
                        </InputAdornment>
                      ),
                    }}
                  />
                  <Field
                    as={TextField}
                    variant="outlined"
                    margin="normal"
                    fullWidth
                    name="password"
                    label="Password"
                    placeholder="Password"
                    type="password"
                    id="password"
                    autoComplete="current-password"
                    error={touched.password && Boolean(errors.password)}
                    helperText={touched.password && errors.password}
                    InputProps={{
                      startAdornment: (
                        <InputAdornment position="start">
                          <LockIcon color="action" />
                        </InputAdornment>
                      ),
                    }}
                  />
                  
                  <Button
                    type="submit"
                    fullWidth
                    variant="contained"
                    sx={{ mt: 3, mb: 1, backgroundColor: 'var(--secondary-accent)' }}
                    disabled={isSubmitting}
                    
                  >
                    Sign In
                  </Button>
                  <Button
                    type="button"
                    fullWidth
                    variant="outlined"
                    sx={{ mb: 2 }}
                    disabled={isSubmitting}
                    onClick={handleRegisterBtn}
                  >
                    Register a new Business!
                  </Button>
  
                  <Box
                    sx={{ 
                      display: 'flex', 
                      flexDirection: 'column',
                      alignItems: 'left', 
                      mt: 2 
                    }}
                  >
                    <Link href="#" variant="body2" disabled={isSubmitting}>
                      Forgot password?
                    </Link>
                  </Box>
                </Form>
              )}
            </Formik>
          </Paper>
        </Container>
      </Box>
    );
  };
  
  export default Login;